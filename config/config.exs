# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :black_swan,
  ecto_repos: [BlackSwan.Repo]

# Configures the endpoint
config :black_swan, BlackSwan.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "3wFJ9aWbFLKSX9KGh0h3iD5gq1c8uBtrkBPBgyUpaqe4eL+MW3MvkHK8FJh+4xgA",
  render_errors: [view: BlackSwan.ErrorView, accepts: ~w(html json)],
  pubsub: [name: BlackSwan.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
