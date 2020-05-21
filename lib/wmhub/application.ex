defmodule Wmhub.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Wmhub.Repo,
      WmhubWeb.Telemetry,
      {Phoenix.PubSub, name: Wmhub.PubSub},
      WmhubWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Wmhub.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    WmhubWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
