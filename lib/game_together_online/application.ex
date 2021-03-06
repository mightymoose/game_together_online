defmodule GameTogetherOnline.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      GameTogetherOnline.Repo,
      # Start the Telemetry supervisor
      GameTogetherOnlineWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: GameTogetherOnline.PubSub},
      # Start the Endpoint (http/https)
      GameTogetherOnlineWeb.Endpoint,
      # Start a worker by calling: GameTogetherOnline.Worker.start_link(arg)
      # {GameTogetherOnline.Worker, arg},
      {Registry, keys: :unique, name: GameTogetherOnline.GameTables.GameTable.Registry},
      {GameTogetherOnline.GameTables, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GameTogetherOnline.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    GameTogetherOnlineWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
