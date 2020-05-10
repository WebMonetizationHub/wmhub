defmodule WmhubWeb.MonetizationChannel do
    use WmhubWeb, :channel

    def subscribe_to_pointer_update(project_id) do
        Phoenix.PubSub.subscribe(WmhubWeb.PubSub, "project-pointer-update:#{project_id}")
    end

    def join("monetization:" <> project_id, _, socket) do
        :ok = ProjectContext.subscribe_to_pointer_update(project_id)
        {:ok, socket}
    end

    def handle_in("monetization-start", %{"requestId" => request_id}, socket) do
        {:noreply, assign(socket, :request_id, request_id)}
    end

    def handle_in("monetization-progress", %{"requestId" => request_id}, %{assigns: %{request_id: request_id}}) do

    end

    def handle_in("monetization-progress", _params, socket) do

    end

    def handle_info({:pointer_update, pointers}, socket) do
        broadcast!(socket, "pointer-update", %{pointers: pointers})
        {:noreply, socket}
    end
end