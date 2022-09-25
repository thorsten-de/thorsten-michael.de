defmodule Tmde.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Tmde.Repo,
      # Start the Telemetry supervisor
      TmdeWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Tmde.PubSub},
      # Start the Endpoint (http/https)
      TmdeWeb.Endpoint,
      # Start a worker by calling: Tmde.Worker.start_link(arg)
      # {Tmde.Worker, arg}
      ChromicPDF
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Tmde.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TmdeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
