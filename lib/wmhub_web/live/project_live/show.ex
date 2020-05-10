defmodule WmhubWeb.ProjectLive.Show do
  use WmhubWeb, :live_view

  alias Wmhub.ProjectContext

  @impl true
  def mount(_params, %{"current_user" => current_user}, socket) do
    {:ok, assign(socket, :current_user, current_user)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:project, ProjectContext.get_project!(id, socket.assigns.current_user.id))}
  end

  defp page_title(:show), do: "Show Project"
  defp page_title(:edit), do: "Edit Project"
end
