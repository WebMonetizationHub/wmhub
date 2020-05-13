defmodule WmhubWeb.ProjectLive.Show do
  use WmhubWeb, :live_view

  alias Wmhub.Projects
  alias Wmhub.Projects.{Project, ProjectsPointers}

  @impl true
  def mount(_params, %{"current_user" => current_user}, socket) do
    {:ok, assign(socket, :current_user, current_user)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:project, get_project(id, socket.assigns.current_user.id))}
  end

  @impl true
  def handle_info({:new_pointer, new_pointer}, socket) do
    Projects.add_new_pointer!(socket.assigns.project, new_pointer)
    {:noreply, assign(socket, :project, get_project(socket.assigns.project.id, socket.assigns.current_user.id))}
  end

  defp get_project(project_id, user_id) do
    Projects.get_project!(project_id, user_id)
  end

  defp page_title(:show), do: "Show Project"
  defp page_title(:edit), do: "Edit Project"

  defp project_code_assigns(%Project{id: project_id, payment_pointers: payment_pointers}) do
    [
      project_id: Wmhub.Projects.signed_token(project_id),
      wmhub_js_file: "http://localhost:4000/wmhub.js",
      payment_pointers: Enum.map(payment_pointers, fn %ProjectsPointers{payment_pointer: payment_pointer} -> payment_pointer  end)
    ]
  end
end
