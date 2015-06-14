defmodule UriTemplate.Mixfile do
  use Mix.Project

  def project do
    [app: :uri_template,
     description: "RFC 6570 complient URI template processor",
     version: "1.0.0",
     elixir: "~> 1.0",
     deps: deps,
     package: package]
  end

  defp git_files do
    System.cmd("git", ["ls-files", "-z"])
      |> (fn {x,_} -> x end).()
      |> String.split(<<0>>)
      |> Enum.filter(fn x -> x != "" end)
  end

  defp package do
    [files: git_files,
      licenses: ["http://opensource.org/licenses/MIT"],
      contributors: ["Peter Williams", "Julius Beckmann"],
      links: %{"homepage": "http://github.com/pezra/ex-uri-template"}]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    []
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    []
  end
end
