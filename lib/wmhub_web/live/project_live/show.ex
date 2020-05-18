defmodule WmhubWeb.ProjectLive.Show do
  use WmhubWeb, :live_view

  alias Wmhub.Projects
  alias Wmhub.Projects.Project

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
    case Projects.add_new_pointer(socket.assigns.project, new_pointer) do
      :ok ->
        {:noreply, assign_get_project(socket)}

      {:error, :multiple_pointers} ->
        {:noreply, put_flash(socket, :error, "Cannot have multiple pointers!")}

      _ ->
        {:noreply, socket}
    end
  end

  @impl true
  def handle_info({:update_pointer, edited_pointer_info}, socket) do
    Projects.edit_pointer!(
      edited_pointer_info.project_pointer_id,
      edited_pointer_info.pointer_value
    )

    {:noreply,
     assign(
       socket,
       :project,
       get_project(socket.assigns.project.id, socket.assigns.current_user.id)
     )}
  end

  defp get_project(project_id, user_id) do
    Projects.get_project!(project_id, user_id)
  end

  defp assign_get_project(socket) do
    assign(
      socket,
      :project,
      get_project(socket.assigns.project.id, socket.assigns.current_user.id)
    )
  end

  defp page_title(:show), do: "Show Project"
  defp page_title(:edit), do: "Edit Project"

  defp project_code_assigns(%Project{id: project_id}) do
    [
      project_id: project_id,
      wmhub_js_file: Routes.static_url(WmhubWeb.Endpoint, "/js/wmhub.js")
    ]
  end
end
