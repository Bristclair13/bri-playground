defmodule BriPlayground.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BriPlaygroundWeb.Telemetry,
      BriPlayground.Repo,
      {DNSCluster, query: Application.get_env(:bri_playground, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: BriPlayground.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: BriPlayground.Finch},
      # Start a worker by calling: BriPlayground.Worker.start_link(arg)
      # {BriPlayground.Worker, arg},
      # Start to serve requests, typically the last entry
      BriPlaygroundWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BriPlayground.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BriPlaygroundWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
