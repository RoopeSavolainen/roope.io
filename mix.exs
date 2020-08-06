defmodule RoopeIO.MixProject do
  use Mix.Project

  def project do
    [
      app: :roopeio,
      version: "0.2.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [
        roopeio: [
          include_executables_for: [:unix],
          steps: [&copy_assets/1, :assemble, :tar, &clean_assets/1],
        ]
      ]
    ]
  end

  defp copy_assets(release) do
    File.cp_r!("./assets", "./rel/overlays/assets")
    release
  end

  defp clean_assets(release) do
    File.rm_rf!("./rel/overlays/assets")
    release
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :runtime_tools, :observer, :wx],
      mod: {RoopeIO.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cowboy, "~> 2.8.0"},
      {:plug_cowboy, "~> 2.3.0"},
      {:earmark, "~> 1.4"}
    ]
  end
end
