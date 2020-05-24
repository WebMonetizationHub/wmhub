defmodule WmhubWeb.DashboardLive.Index do
  use WmhubWeb, :live_view
  alias Wmhub.Payments

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
