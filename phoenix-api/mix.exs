defmodule UserManagement.MixProject do
  use Mix.Project

  def project do
    [
      app: :user_management,
      version: "0.1.0",
      elixir: "1.19.4",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [
        user_management: [
          include_executables_for: [:unix],
          applications: [
            user_management: :permanent,
            plug_cowboy: :permanent
          ]
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :runtime_tools],
      mod: {UserManagement.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:phoenix, "~> 1.8.3"},
      {:phoenix_ecto, "~> 4.5"},
      {:ecto_sql, "~> 3.6"},
      {:postgrex, ">= 0.0.0"},
      {:swoosh, "~> 1.16"},
      {:req, "~> 0.5"},
      {:gettext, "~> 1.0"},
      {:jason, "~> 1.2"},
      {:dns_cluster, "~> 0.2.0"},
      {:plug_cowboy, "~> 2.7"},
      {:hackney, "~> 1.25.0"},
    ]
  end
end
