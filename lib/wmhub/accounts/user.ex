defmodule Wmhub.Accounts.User do
  use Ecto.Schema
  use Pow.Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    field :email, :string
    field :name, :string
    pow_user_fields()
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password_hash])
    |> validate_required([:name, :email])
    |> pow_changeset(attrs)
  end
end
