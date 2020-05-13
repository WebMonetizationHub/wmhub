defmodule Wmhub.Projects.Project do
  use Ecto.Schema
  import Ecto.Changeset
  alias Wmhub.Accounts.User
  alias Wmhub.Projects.ProjectsPointers

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "projects" do
    field :description, :string
    field :name, :string
    field :url, :string
    field :active, :boolean, default: true
    belongs_to :user, User, type: :binary_id
    has_many :payment_pointers, ProjectsPointers

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:name, :description, :url, :active, :user_id])
    |> validate_required([:name, :description, :url, :user_id])
    |> unique_constraint(:email)
  end
end
