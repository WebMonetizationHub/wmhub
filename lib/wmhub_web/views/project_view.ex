defmodule WmhubWeb.ProjectView do
    use WmhubWeb, :view

    def render("project.json", %{project: project}) do
        %{
            id: project.id,
            name: project.name,
            description: project.description,
        }
    end
end