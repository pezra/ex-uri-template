defmodule UriTemplate.Mixfile do
  use Mix.Project

  @source_url "http://github.com/pezra/ex-uri-template"
  @version "1.2.1"

  def project do
    [
      app: :uri_template,
      version: @version,
      elixir: "~> 1.3",
      deps: deps(),
      docs: docs(),
      package: package()
    ]
  end

  defp git_files do
    System.cmd("git", ["ls-files", "-z"])
    |> (fn {x, _} -> x end).()
    |> String.split(<<0>>)
    |> Enum.filter(fn x -> x != "" end)
  end

  defp package do
    [
      description: "RFC 6570 compliant URI template processor",
      files: git_files(),
      licenses: ["MIT"],
      contributors: ["Peter Williams", "Julius Beckmann"],
      links: %{GitHub: @source_url}
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:poison, "~> 1.4", only: :test},
      {:earmark, ">= 0.0.0", only: :dev},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp docs do
    [
      extras: [
        "README.md": [title: "Overview"]
      ],
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}",
      formatters: ["html"]
    ]
  end
end
