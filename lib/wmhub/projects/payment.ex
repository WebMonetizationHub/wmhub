defmodule Wmhub.Projects.Payment do
    use Wmhub.Schema

    alias Wmhub.Projects.Project

    @fields ~w[request_id asset_scale amount asset_code payment_pointer payment_date project_id]a
    @required_fields ~w[request_id asset_scale amount asset_code payment_pointer payment_date project_id]a

    schema "projects_payments" do
        field :request_id, :binary_id
        field :asset_scale, :integer
        field :amount, :integer, default: 0
        field :asset_code, :string
        field :payment_pointer, :string
        field :payment_date, :utc_datetime

        belongs_to :project, Project
    end

    def changeset(payments, params) do
        payments
        |> cast(params, @fields)
        |> validate_required(@required_fields)
    end
end