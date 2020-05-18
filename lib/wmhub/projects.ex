defmodule Wmhub.Projects do
  @moduledoc """
  The Projects context.
  """

  import Ecto.Query, warn: false
  alias Wmhub.Repo

  alias Wmhub.Projects.{Project, ProjectsPointers}
  alias Wmhub.Pointers

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
  def get_project_for_user!(id, user_id) do
    Repo.one!(
      from p in Project,
        left_join: pointers in ProjectsPointers,
        on: p.id == pointers.project_id,
        where: p.id == ^id and p.user_id == ^user_id,
        preload: [payment_pointers: pointers]
    )
  end

  def get_project!(id) do
    Repo.get!(Project, id)
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

    Repo.query(query, [id, user_id] |> Enum.map(&UUID.string_to_binary!/1))
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

  def add_new_pointer(%Project{payment_pointers: []} = project, new_pointer) do
    new_project_pointer = Ecto.build_assoc(project, :payment_pointers)
    changeset = ProjectsPointers.changeset(new_project_pointer, %{payment_pointer: new_pointer})

    case Repo.insert(changeset) do
      {:ok, _project_pointer} ->
        project_pointers = Repo.all(get_pointer_list_query(new_project_pointer.project_id))
        broadcast_pointers({:pointer_update, new_project_pointer.project_id, project_pointers})

      {:error, error} ->
        {:error, error}
    end
  end

  def add_new_pointer(%Project{}, _new_pointer) do
    {:error, :multiple_pointers}
  end

  def edit_pointer!(project_pointer_id, new_pointer_value) do
    project_pointer = Repo.get!(ProjectsPointers, project_pointer_id)
    changeset = ProjectsPointers.changeset(project_pointer, %{payment_pointer: new_pointer_value})
    Repo.update!(changeset)
    project_pointers = Repo.all(get_pointer_list_query(project_pointer.project_id))
    :ok = broadcast_pointers({:pointer_update, project_pointer.project_id, project_pointers})
  end

  defp broadcast_pointers({:pointer_update, project_id, project_pointers}) do
    Pointers.broadcast_update!(
      project_id,
      Enum.map(project_pointers, & &1.payment_pointer)
    )
  end

  defp get_pointer_list_query(project_id) do
    from(p in Project,
      join: pointers in ProjectsPointers,
      on: p.id == pointers.project_id,
      select: pointers,
      where: p.id == ^project_id
    )
  end
end
