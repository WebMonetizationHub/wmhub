defmodule Wmhub.Projects.ProjectsPointers do
    use Ecto.Schema
    import Ecto.Changeset
    alias Wmhub.Projects.Project

    @primary_key {:id, :binary_id, autogenerate: true}
    @foreign_key_type :binary_id

    schema "projects_pointers" do
        field :payment_pointer, :string
        field :active, :boolean, default: false
        field :weight, :integer

        belongs_to :project, Project
    end

    def changeset(projects_pointers, attrs) do
        projects_pointers
        |> cast(attrs, [:payment_pointer, :active, :weight, :project_id])
        |> validate_required([:payment_pointer, :project_id])
        # TODO: validate that the weight distribution for multiple payment pointers amounts to 100
    end
end