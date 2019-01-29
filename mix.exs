defmodule CubaLibrato.MixProject do
  use Mix.Project

  def project do
    [
      app: :cuba_librato,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      preferred_cli_env: ["test.watch": :test],
      escript: escript()
    ]
  end

  defp escript() do
    [main_module: CubaLibrato.CLI]
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
      {:httpoison, "~> 1.5"},
      {:jason, "~> 1.1"},
      {:mix_test_watch, "~> 0.9.0", only: :test, runtime: false}
    ]
  end
end
