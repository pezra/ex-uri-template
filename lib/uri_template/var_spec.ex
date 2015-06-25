defmodule UriTemplate.VarSpec do
  @moduledoc """
  Represents a single varspec from a URI template expression.
  """

  defstruct [:name, :key, :limit]

  @doc """
  Parses `varspec_str` and returns a `UriTemplate.VarSpec struct representing
  it.
  """
  def from_string(varspec_str) do
    %{"name" => name, "limit" => lim} =
      Regex.named_captures(~r/(?<name>[^\:]+)[:]?(?(?<=:)(?<limit>[\d]+))/, varspec_str)

    {limit, _} = case lim do
                   "" -> {:none, nil}
                   _ -> Integer.parse(lim)
                 end

    %__MODULE__{name: name, key: :"#{name}", limit: limit}
  end

  @doc """
  Returns a tuple with `:ok` followed by URI encoded value of the variable
  specified. If there is no such variable (or its value is blank `:missing`
  is returned
  """
  def fetch(vars, varspec, encode_value? \\ true) do
    case Dict.fetch(vars, varspec.key) do
      {:ok, nil} -> :missing
      {:ok, ""}  -> :missing
      :error     -> :missing
      {:ok, val} -> {:ok, val |> render_to_string(char_pred(encode_value?), varspec.limit)}
    end
  end

  @doc """
  Returns the URI encoded value of the variable specified, or the default
  """
  def get(vars, varspec, default \\ "", encode_value? \\ true) do
    case fetch(vars, varspec, encode_value?) do
      {:ok, val} -> val
      :missing   -> default |> render_to_string(char_pred(encode_value?), varspec.limit)
    end
  end

  # render a Keywords list to a string
  defp render_to_string(vals, esc_char_pred, limit) when (is_list(vals) and is_tuple(hd(vals)) and tuple_size(hd(vals)) == 2) or is_map(vals) do
    vals
    |> Enum.flat_map(fn {a,b} -> [a,b] end)
    |> render_to_string(esc_char_pred, limit)
  end

  # render a normal list to a string
  defp render_to_string(vals, esc_char_pred, limit) when is_list(vals) do
    vals
    |> Enum.map(&render_to_string(&1, esc_char_pred, limit))
    |> Enum.join(",")
  end

  # render anything else ito a string
  defp render_to_string(val, esc_char_pred, :none) do
    val |> to_string |> URI.encode(esc_char_pred)
  end

  # render anything else ito a string
  defp render_to_string(val, esc_char_pred, limit) do
    val |> to_string |> String.slice(0..(limit-1)) |> URI.encode(esc_char_pred)
  end

  defp char_pred(true) do
    &URI.char_unreserved?/1
  end

  defp char_pred(false) do
    &URI.char_unescaped?/1
  end
end

