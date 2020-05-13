defmodule Wmhub.Projects do
  @moduledoc """
  The Projects context.
  """

  import Ecto.Query, warn: false
  alias Wmhub.Repo

  alias Wmhub.Projects.{Project, ProjectsPointers}

  @doc """
  Returns the list of projects.

  ## Examples

      iex> list_projects()
      [%Project{}, ...]

  """
  def list_projects(user_id) do
    Repo.all(from p in Project, where: p.active == true and p.user_id == ^user_id)
  end

  @doc """
  Gets a single project.

  Raises `Ecto.NoResultsError` if the Project does not exist.

  ## Examples

      iex> get_project!(123)
      %Project{}

      iex> get_project!(456)
      ** (Ecto.NoResultsError)

  """
  def get_project!(id, user_id) do
    Repo.one!(
      from p in Project,
      left_join: pointers in ProjectsPointers,
      on: p.id == pointers.project_id,
      where: p.id == ^id and p.user_id == ^user_id,
      preload: [payment_pointers: pointers]
    )
  end

  @doc """
  Creates a project.

  ## Examples

      iex> create_project(%{field: value})
      {:ok, %Project{}}

      iex> create_project(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_project(attrs \\ %{}) do
    %Project{}
    |> Project.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a project.

  ## Examples

      iex> update_project(project, %{field: new_value})
      {:ok, %Project{}}

      iex> update_project(project, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_project(%Project{} = project, attrs) do
    project
    |> Project.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a project.

  ## Examples

      iex> delete_project(project)
      {:ok, %Project{}}

      iex> delete_project(project)
      {:error, %Ecto.Changeset{}}

  """
  def delete_project(id, user_id) do
    query = """
    UPDATE projects SET active = false WHERE id = $1 AND user_id = $2
    """
    Repo.query!(query, [id, user_id] |> Enum.map(&UUID.string_to_binary!/1))
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project changes.

  ## Examples

      iex> change_project(project)
      %Ecto.Changeset{data: %Project{}}

  """
  def change_project(%Project{} = project, attrs \\ %{}) do
    Project.changeset(project, attrs)
  end

  def add_new_pointer!(%Project{} = project, new_pointer) do
    new_project_pointer = Ecto.build_assoc(project, :payment_pointers)
    changeset = ProjectsPointers.changeset(new_project_pointer, %{payment_pointer: new_pointer})
    Repo.insert! changeset
  end

  def signed_token(project_id) do
    Phoenix.Token.sign(WmhubWeb.Endpoint, "wmhub code snippet", project_id)
  end
end
