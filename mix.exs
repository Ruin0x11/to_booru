defmodule ToBooru.MixProject do
  use Mix.Project

  def project do
    [
      app: :to_booru,
      version: "0.1.0",
      elixir: "~> 1.10",
      elixirc_paths: elixirc_paths(Mix.env),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ToBooru.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tesla, "~> 1.3.0"},
      {:hackney, "~> 1.17.4"},
      {:ibrowse, "~> 4.4.0"},
      {:jason, ">= 1.0.0"},
      {:floki, "~> 0.26.0"},
      {:extwitter, "~> 0.12.0"},
      {:oauther, github: "tobstarr/oauther", override: true}, # https://github.com/lexmag/oauther/pull/22
      {:pixiv, github: "Ruin0x11/Pixiv.ex"},

      {:credo, "~> 1.1", only: :dev, runtime: false},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:exvcr, "~> 0.11", only: :test},
      {:assertions, "~> 0.18.1", only: :test}
    ]
  end
end
