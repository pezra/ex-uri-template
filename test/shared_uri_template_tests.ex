defmodule SharedUriTemplateTests do
  @doc """
    Returns Enum of example from the specified suite in uritemplate-tests project.
  """
  def examples_in(suite_name) do
    raw_examples(suite_name)
    |> Enum.flat_map(&group_to_examples/1)
  end

  defp group_to_examples({name, info}) do
    Dict.fetch!(info, "testcases")
    |> Enum.map(fn [tmpl, expected] ->
      %{ group: name,
         level: Dict.get(info, "level", 4),
         vars: Dict.fetch!(info, "variables") |> symbolize_keys,
         tmpl: tmpl,
         expected: expected }
    end)
  end

  defp symbolize_keys(a_map) do
    a_map
    |> Enum.map(fn {k,v} -> {:"#{k}", v} end)
    |> Enum.into(%{})
  end

  defp raw_examples(suite_name) do
    File.read!(examples_file(suite_name))
    |> Poison.Parser.parse!()
  end

  defp examples_file(name) do
    __DIR__ <> "/../vendor/uritemplate-test/#{name}.json"
  end

end
