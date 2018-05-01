Code.load_file("shared_uri_template_tests.ex", __DIR__)

defmodule UriTemplateTest do
  use ExUnit.Case, async: true

  doctest UriTemplate

  (SharedUriTemplateTests.examples_in("spec-examples") ++
     SharedUriTemplateTests.examples_in("extended-tests") ++
     SharedUriTemplateTests.examples_in("negative-tests"))
  |> Enum.filter(fn %{level: level} -> level < 4 end)
  |> Enum.map(fn %{vars: vars, tmpl: tmpl, expected: exp, group: group} ->
    expected =
      case exp do
        _ when is_list(exp) -> exp
        _ -> [exp]
      end

    {vars, tmpl, expected, group}
  end)
  |> Enum.each(fn {vars, tmpl, expected, group} ->
    @vars vars
    test "#{group}: <#{tmpl}>",
      do: assert(UriTemplate.expand(unquote(tmpl), @vars) in unquote(expected))
  end)
end
