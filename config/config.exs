# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :wmhub,
  ecto_repos: [Wmhub.Repo]

# Configures the endpoint
config :wmhub, WmhubWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "qpyIejtAlZtGEiFipRMTevK/f1FAWZY8IamA6bJTf/bvFBwWjL6C8Wyz9fUcNYcS",
  render_errors: [view: WmhubWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Wmhub.PubSub,
  live_view: [signing_salt: "zuuaOBED"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :wmhub, :pow,
  user: Wmhub.Accounts.User,
  users_context: Wmhub.Accounts,
  repo: Wmhub.Repo,
  web_module: WmhubWeb


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
