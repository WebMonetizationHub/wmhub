defmodule Wmhub.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :name, :string
      add :description, :string
      add :url, :string
      add :active, :boolean
      add :user_id, references("users", type: :uuid)

      timestamps()
    end
  end
end
