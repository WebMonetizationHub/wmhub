defmodule Wmhub.Projects.Project do
  use Wmhub.Schema
  
  alias Wmhub.Accounts.User
  alias Wmhub.Projects.Pointer

  schema "projects" do
    field :description, :string
    field :name, :string
    field :url, :string
    field :active, :boolean, default: true

    belongs_to :user, User, type: :binary_id
    has_many :payment_pointers, Pointer

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
