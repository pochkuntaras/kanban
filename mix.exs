defmodule Kanban.MixProject do
  use Mix.Project

  def project do
    [
      app: :kanban,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Kanban.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:finitomata, "~> 0.9.1"},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:siblings, "~> 0.1"},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.16.5"}
    ]
  end
end
