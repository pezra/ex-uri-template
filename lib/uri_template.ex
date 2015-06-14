defmodule UriTemplate do
  @doc """
    Expand a RFC 6570 compliant URI template in to a full URI.

    ## Examples

        iex> UriTemplate.expand("http://example.com/{id}", id: 42)
        "http://example.com/42"

        iex> UriTemplate.expand("http://example.com/test", id: 42)
        "http://example.com/test"

        iex> UriTemplate.expand("http://example.com/{lat,lng}", lat: 40, lng: -105)
        "http://example.com/40,-105"

        iex> UriTemplate.expand("http://example.com/{lat,lng}", lat: 40, lng: -105)
        "http://example.com/40,-105"

        iex> UriTemplate.expand("http://example.com/{;lat,lng}", lat: 40, lng: -105)
        "http://example.com/;lat=40;lng=-105"

        iex> UriTemplate.expand("http://example.com/{?lat,lng}", lat: 40, lng: -105)
        "http://example.com/?lat=40&lng=-105"

        iex> UriTemplate.expand("http://example.com/?test{&lat,lng}", lat: 40, lng: -105)
        "http://example.com/?test&lat=40&lng=-105"

        iex> UriTemplate.expand("http://example.com{/lat,lng}", lat: 40, lng: -105)
        "http://example.com/40/-105"

        iex> UriTemplate.expand("http://example.com/test{.fmt}", fmt: "json")
        "http://example.com/test.json"

        iex> UriTemplate.expand("http://example.com{#lat,lng}", lat: 40, lng: -105)
        "http://example.com#40,-105"

  """
  def expand(tmpl, vars) do
    Regex.scan(~r/([^{]*)(?:{([^}]+)})?/, tmpl, capture: :all_but_first)
    |> Enum.flat_map(&expand_part(vars, &1))
    |> Enum.join
  end

  defp expand_part(vars, [prefix, expr]) do
    [prefix, expand_expression(expr, vars)]
  end

  defp expand_part(vars, [prefix]) do
    [prefix]
  end

  defp expand_expression(expression, vars) do
    {op, leaders, varnames} = parse_expression(expression)

    Enum.map(varnames, &expand_varspec(&1, vars, op))
    |> Stream.zip(leaders)
    |> Enum.flat_map(fn {expanded_varspec, leader} -> [leader, expanded_varspec] end)
    |> Enum.join
  end

  defp expand_varspec(varspec, vars, op) do
    val = Dict.get(vars, varspec, "") |> to_string

    cond do
      name_value_pair_op?(op) -> "#{varspec}=#{val}"
      true -> to_string(val)
    end
  end

  defp parse_expression(expression) do
    %{"op" => op, "vars" => varlist} =
      Regex.named_captures(~r/(?<op>[+\#.\/;?&=,!@|]?)(?<vars>.*)/, expression)

    varspecs = String.split(varlist, ",") |> Enum.map(&:"#{&1}")

    {op, leaders_stream_for(op), varspecs}
  end

  defp name_value_pair_op?(op), do: Enum.member?([";","?","&"], op)

  defp leaders_stream_for(op) do
    case op do
      ""  -> Stream.iterate("",  fn _ -> "," end)
      "#" -> Stream.iterate("#", fn _ -> "," end)
      "?" -> Stream.iterate("?", fn _ -> "&" end)
      _   -> Stream.cycle([op])
    end

  end
end
