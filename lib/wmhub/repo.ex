defmodule Wmhub.Repo do
  use Ecto.Repo,
    otp_app: :wmhub,
    adapter: Ecto.Adapters.Postgres
end
