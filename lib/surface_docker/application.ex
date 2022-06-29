defmodule SurfaceDocker.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      SurfaceDockerWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: SurfaceDocker.PubSub},
      # Start the Endpoint (http/https)
      SurfaceDockerWeb.Endpoint
      # Start a worker by calling: SurfaceDocker.Worker.start_link(arg)
      # {SurfaceDocker.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SurfaceDocker.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SurfaceDockerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
