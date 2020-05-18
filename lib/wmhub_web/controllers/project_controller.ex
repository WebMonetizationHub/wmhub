defmodule WmhubWeb.ProjectController do
    use WmhubWeb, :controller
    alias Wmhub.Projects

    def index(conn, %{"id" => id}) do
        project = Projects.get_project!(id)
        render(conn, "project.json", project: project)
    end
end