defmodule PlugTestHelpers.Mixfile do
  use Mix.Project

  def project do
    [app: :plug_test_helpers,
     version: "0.1.0",
     elixir: "~> 1.0",
     deps: deps,
     description: description,
     package: package,
     source_url: "https://github.com/xavier/plug_test_helpers",
     homepage_url: "https://github.com/xavier/plug_test_helpers"]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :plug, :cowboy]]
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
    [
      {:plug, "~> 0.8.0"},
      {:cowboy, "~> 1.0.0"},
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.6", only: :dev}
   ]
  end

  defp description do
    "Helpers to test your Plugs with ExUnit"
  end

  defp package do
    [
     files: ["lib", "priv", "mix.exs", "README*", "LICENSE*"],
     contributors: ["Xavier Defrang"],
     licenses: ["Apache 2.0"],
     links: %{"GitHub" => "https://github.com/xavier/plug_test_helpers"}
   ]
  end
end
