defmodule Tmde.MixProject do
  use Mix.Project

  def project do
    [
      app: :tmde,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(Mix.env())
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Tmde.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # As I publish my app within a docker container, I don't want to use a local copy of
  # bulma_liveview repo in production. It should just pull the current version from
  # github (or perhaps hex.pm if it will be published where)
  defp deps(:prod) do
    [
      {:bulma_liveview, github: "thorsten-de/bulma_liveview", branch: "1-liveview-018"}
      | deps()
    ]
  end

  # As I want to evolve my bulma-liveview components along the way, I have a local
  # remote of the github repository setup in development/test mode.
  defp deps(_) do
    [
      {:bulma_liveview, path: "../bulma_liveview"}
      | deps()
    ]
  end

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.7.0"},
      {:phoenix_ecto, "~> 4.4"},
      {:ecto_sql, "~> 3.6"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.18.3"},
      {:floki, ">= 0.30.0", only: :test},
      {:phoenix_live_dashboard, "~> 0.7"},
      {:esbuild, "~> 0.4", runtime: Mix.env() == :dev},
      {:dart_sass, "~> 0.5", runtime: Mix.env() == :dev},
      # forked from kevinlang/bulma-elixir (bulma in hex) to support v0.9.4
      {:bulma, "0.9.4"},
      {:deepl_ex, "0.1.0", github: "thorsten-de/deepl_ex"},
      {:earmark, "~> 1.4"},
      {:nimble_publisher, "~>1.0"},
      {:makeup_elixir, "~> 0.1"},
      {:makeup_erlang, "~> 0.1"},
      {:chromic_pdf, "~> 1.2"},
      {:qr_code, "~> 3.0"},
      {:timex, "~>3.7"},
      {:remote_ip, "~>1.0"},
      {:swoosh, "~> 1.3"},
      {:gen_smtp, "~> 1.1"},
      {:phoenix_swoosh, "~> 1.0"},
      {:pbkdf2_elixir, "~>2.0"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.18"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.deploy": [
        "esbuild default --minify",
        "sass default --no-source-map --style=compressed",
        "phx.digest"
      ]
    ]
  end
end
