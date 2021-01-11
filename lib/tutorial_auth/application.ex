defmodule TutorialAuth.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      TutorialAuth.Repo,
      # Start the Telemetry supervisor
      TutorialAuthWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: TutorialAuth.PubSub},
      # Start the Endpoint (http/https)
      TutorialAuthWeb.Endpoint
      # Start a worker by calling: TutorialAuth.Worker.start_link(arg)
      # {TutorialAuth.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TutorialAuth.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TutorialAuthWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
