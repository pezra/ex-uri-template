defmodule UriTemplate do
  @moduledoc """

    [RFC 6570](https://tools.ietf.org/html/rfc6570) compliant URI template
    processor. Currently supports level 3.
  """
  alias UriTemplate.Expression, as: Expression

  defstruct [:parts]

  @doc """
    Expand a RFC 6570 compliant URI template in to a full URI.

    ## Examples

        iex> UriTemplate.expand("http://example.com/{id}", id: 42)
        "http://example.com/42"

        iex> UriTemplate.expand("http://example.com?q={terms}", terms: ["fiz", "buzz"])
        "http://example.com?q=fiz,buzz"

        iex> UriTemplate.expand("http://example.com?{k}", k: [one: 1, two: 2])
        "http://example.com?one,1,two,2"

        iex> UriTemplate.expand("http://example.com/test", id: 42)
        "http://example.com/test"

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
  def expand(tmpl, vars) when is_binary(tmpl) do
    __MODULE__.from_string(tmpl)
    |> expand(vars)
  end

  @doc """
  Expands a preparsed template.

  ## Examples

    iex> tmpl = UriTemplate.from_string "http://example.com/{id}"
    ...> UriTemplate.expand(tmpl,  id: 42)
    "http://example.com/42"
  """
  def expand(tmpl, vars) when is_map(tmpl) do
    tmpl.parts
    |> Enum.map(&expand_part(&1, vars))
    |> Enum.join
  end

  @doc """
  Returns a parsed template that can be expanded repeatedly with different variables.

  ## Examples

    iex> tmpl = UriTemplate.from_string "http://example.com/{id}"
    ...> UriTemplate.expand(tmpl,  id: 42)
    "http://example.com/42"
  """
  def from_string(tmpl_str) do
    %UriTemplate{parts: parse_template(tmpl_str) }
  end

  defp parse_template(str) do
    Regex.scan(~r/([^{]*)(?:{([^}]+)})?/, str, capture: :all_but_first)
    |> Enum.flat_map(&parse_part(&1))
  end

  defp expand_part(part, _) when is_binary(part) do
    part
  end

  defp expand_part(expr, vars) do
    Expression.expand(expr, vars)
  end

  defp parse_part([prefix, expr_str]) do
    [prefix, Expression.from_string(expr_str)]
  end

  defp parse_part([prefix]) do
    [prefix]
  end
end
