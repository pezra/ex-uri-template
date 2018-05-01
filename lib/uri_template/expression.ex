defmodule UriTemplate.Expression do
  @moduledoc """
  Represents an URI template expression (the bits surrounded in curly braces).
  """

  alias UriTemplate.VarSpec, as: VarSpec

  defstruct [:op, :varspecs, :leaders]

  @doc """
  Returns a parsed expression that can be expanded using the `expand/2` function.
  """
  def from_string(expr_str) do
    %{"op" => op, "vars" => varlist} =
      Regex.named_captures(~r/(?<op>[+\#.\/;?&=,!@|]?)(?<vars>.*)/, expr_str)

    %__MODULE__{
      op: op,
      varspecs: String.split(varlist, ",") |> Enum.map(&VarSpec.from_string/1),
      leaders: leaders_stream_for(op)
    }
  end

  @doc """
  Returns the expanded expression as a string.
  """
  def expand(expression, vars) do
    expression.varspecs
    |> Enum.map(&expand_varspec(&1, vars, expression.op))
    |> Stream.zip(expression.leaders)
    |> Enum.flat_map(fn {expanded_varspec, leader} -> [leader, expanded_varspec] end)
    |> Enum.join()
  end

  defp expand_varspec(varspec, vars, op) do
    cond do
      name_value_pair_op?(op) -> expand_nvp_varspec(varspec, vars, op == ";")
      op in ["+", "#"] -> raw_expand_varspec(varspec, vars)
      true -> expand_basic_varspec(varspec, vars)
    end
  end

  defp expand_nvp_varspec(varspec, vars, skip_eq_if_blank) do
    _val = expand_basic_varspec(varspec, vars)

    case {VarSpec.fetch(vars, varspec), skip_eq_if_blank} do
      {{:ok, val}, _} -> "#{varspec.name}=#{val}"
      {:missing, true} -> varspec.name
      {:missing, false} -> "#{varspec.name}="
    end
  end

  defp expand_basic_varspec(varspec, vars) do
    VarSpec.get(vars, varspec, "")
  end

  defp raw_expand_varspec(varspec, vars) do
    VarSpec.get(vars, varspec, "", false)
  end

  defp name_value_pair_op?(op), do: Enum.member?([";", "?", "&"], op)

  defp leaders_stream_for(op) do
    case op do
      "" -> Stream.iterate("", fn _ -> "," end)
      "#" -> Stream.iterate("#", fn _ -> "," end)
      "+" -> Stream.iterate("", fn _ -> "," end)
      "?" -> Stream.iterate("?", fn _ -> "&" end)
      _ -> Stream.cycle([op])
    end
  end
end
