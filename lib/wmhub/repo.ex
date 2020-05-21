defmodule Wmhub.Repo do
  @moduledoc """
  The Wmhub Ecto.Repo module. Deals with the database.
  See `Ecto.Repo`.
  """
  use Ecto.Repo,
    otp_app: :wmhub,
    adapter: Ecto.Adapters.Postgres
end
