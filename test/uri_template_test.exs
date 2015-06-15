Code.load_file "shared_uri_template_tests.ex", __DIR__

defmodule UriTemplateTest do
  use ExUnit.Case, async: true

  doctest UriTemplate

  (SharedUriTemplateTests.examples_in("spec-examples")
   ++ SharedUriTemplateTests.examples_in("extended-tests")
   ++ SharedUriTemplateTests.examples_in("negative-tests"))
  |> Enum.filter(fn %{level: l} -> l < 4 end)
  |> Enum.each(fn %{vars: vars, tmpl: tmpl, expected: expected, group: group} ->
    @vars vars
    test "#{group}: <#{tmpl}>", do: assert UriTemplate.expand(unquote(tmpl), @vars) == unquote(expected)
  end)
end
