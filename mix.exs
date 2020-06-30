defmodule ToBooru.MixProject do
  use Mix.Project

  def project do
    [
      app: :to_booru,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

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
      {:hackney, "~> 1.15.2"},
      {:jason, ">= 1.0.0"},
      {:floki, "~> 0.26.0"},
      {:oauther, "~> 1.1"},
      {:extwitter, "~> 0.12.0"},
      {:pixiv, github: "Ruin0x11/Pixiv.ex"},

      {:credo, "~> 1.1", only: :dev, runtime: false},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
    ]
  end
end
