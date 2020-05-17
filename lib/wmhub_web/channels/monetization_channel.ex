defmodule WmhubWeb.MonetizationChannel do
  use WmhubWeb, :channel

  def join("monetization:" <> project_id, _, socket) do
    send(self(), :after_join)
    {:ok, assign(socket, :project_id, project_id)}
  end

  def handle_in("monetization-start", %{"requestId" => request_id}, socket) do
    {:noreply, assign(socket, :request_id, request_id)}
  end

  def handle_in(
        "monetization-progress",
        %{"requestId" => request_id},
        %{assigns: %{request_id: request_id}} = socket
      ) do
    {:noreply, socket}
  end

  def handle_in("monetization-progress", _params, socket) do
    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    Wmhub.Pointers.subscribe_for_updates(socket.assigns.project_id)
    {:noreply, socket}
  end

  def handle_info({:pointer_update, pointers}, socket) do
    push(socket, "pointer-update", %{pointers: pointers})
    {:noreply, socket}
  end
end
