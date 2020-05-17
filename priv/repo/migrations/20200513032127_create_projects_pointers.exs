defmodule Wmhub.Repo.Migrations.CreateProjectsPointers do
  use Ecto.Migration

  def change do
    create table(:projects_pointers) do
      add :project_id, references("projects", type: :uuid)
      add :payment_pointer, :string
      add :active, :boolean
      add :weight, :integer
    end
  end
end
