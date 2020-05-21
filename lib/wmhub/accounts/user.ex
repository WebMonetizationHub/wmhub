defmodule Wmhub.Accounts.User do
  @moduledoc """
  Describes a user of the system.
  Users can create projects and see dashboards. Mainly, they represent
  WMHub's paying customers.
  """
  use Wmhub.Schema
  use Pow.Ecto.Schema

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
