defmodule Wmhub.ProjectContextTest do
  use Wmhub.DataCase

  alias Wmhub.ProjectContext

  describe "projects" do
    alias Wmhub.ProjectContext.Project

    @valid_attrs %{description: "some description", name: "some name", url: "some url"}
    @update_attrs %{description: "some updated description", name: "some updated name", url: "some updated url"}
    @invalid_attrs %{description: nil, name: nil, url: nil}

    def project_fixture(attrs \\ %{}) do
      {:ok, project} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ProjectContext.create_project()

      project
    end

    test "list_projects/0 returns all projects" do
      project = project_fixture()
      assert ProjectContext.list_projects() == [project]
    end

    test "get_project!/1 returns the project with given id" do
      project = project_fixture()
      assert ProjectContext.get_project!(project.id) == project
    end

    test "create_project/1 with valid data creates a project" do
      assert {:ok, %Project{} = project} = ProjectContext.create_project(@valid_attrs)
      assert project.description == "some description"
      assert project.name == "some name"
      assert project.url == "some url"
    end

    test "create_project/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ProjectContext.create_project(@invalid_attrs)
    end

    test "update_project/2 with valid data updates the project" do
      project = project_fixture()
      assert {:ok, %Project{} = project} = ProjectContext.update_project(project, @update_attrs)
      assert project.description == "some updated description"
      assert project.name == "some updated name"
      assert project.url == "some updated url"
    end

    test "update_project/2 with invalid data returns error changeset" do
      project = project_fixture()
      assert {:error, %Ecto.Changeset{}} = ProjectContext.update_project(project, @invalid_attrs)
      assert project == ProjectContext.get_project!(project.id)
    end

    test "delete_project/1 deletes the project" do
      project = project_fixture()
      assert {:ok, %Project{}} = ProjectContext.delete_project(project)
      assert_raise Ecto.NoResultsError, fn -> ProjectContext.get_project!(project.id) end
    end

    test "change_project/1 returns a project changeset" do
      project = project_fixture()
      assert %Ecto.Changeset{} = ProjectContext.change_project(project)
    end
  end
end
