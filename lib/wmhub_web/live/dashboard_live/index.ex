defmodule WmhubWeb.DashboardLive.Index do
  use WmhubWeb, :live_view
  alias Wmhub.Payments

  def mount(_params, %{"current_user" => current_user}, socket) do
    payments = Payments.sum_per_project(current_user.id)
    socket = socket
    |> assign(:current_user, current_user)
    |> assign(:payments, payments)
    {:ok, socket}
  end
end
