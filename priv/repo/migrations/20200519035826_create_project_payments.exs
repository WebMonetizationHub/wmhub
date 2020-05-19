defmodule Wmhub.Repo.Migrations.CreateProjectPayments do
  use Ecto.Migration

  def change do
    create table(:projects_payments) do
      add :request_id, :uuid
      add :asset_scale, :integer
      add :amount, :integer
      add :asset_code, :string
      add :payment_pointer, :string
      add :payment_date, :utc_datetime
      add :project_id, references("projects", type: :uuid)
    end
  end
end
