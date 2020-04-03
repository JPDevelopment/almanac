defmodule Almanac.MixProject do
  use Mix.Project

  def project do
    [
      app: :almanac,
      escript: escript_config(),
      version: "0.1.0",
      name: "Almanac",
      source_url: "https://github.com/JPDevelopment/almanac",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.6"},
      {:sweet_xml, "~> 0.6.6"},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:earmark, "~> 1.4.3"}

    ]
  end
  defp escript_config do
    [
      main_module: Almanac.CLI
    ]
  end
end
