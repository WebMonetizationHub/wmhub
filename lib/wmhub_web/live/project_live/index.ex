defmodule WmhubWeb.ProjectLive.Index do
  use WmhubWeb, :live_view

  alias Wmhub.ProjectContext
  alias Wmhub.ProjectContext.Project

  @impl true
  def mount(_params, %{"current_user" => current_user}, socket) do
    socket = socket
    |> assign(:current_user, current_user)
    |> assign(:projects, fetch_projects(current_user.id))
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Project")
    |> assign(:project, ProjectContext.get_project!(id, socket.assigns.current_user.id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Project")
    |> assign(:project, %Project{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Projects")
    |> assign(:project, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    {:ok, _} = ProjectContext.delete_project(id, socket.assigns.current_user.id)

    {:noreply, assign(socket, :projects, fetch_projects(socket.assigns.current_user.id))}
  end

  defp fetch_projects(user_id) do
    ProjectContext.list_projects(user_id)
  end
end
