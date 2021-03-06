defmodule Rememberex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :rememberex,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :mnesia],
      mod: {Rememberex.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
  [
    {:benchee, "~> 0.10.0"},
    {:benchee_csv, "~> 0.7.0"}

    ]
  end
end
