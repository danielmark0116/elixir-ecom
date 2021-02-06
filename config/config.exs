# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :server,
  namespace: Ecom,
  ecto_repos: [Ecom.Repo]

# Configures the endpoint
config :server, EcomWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "I+G8PBenkLaTG6Q8yxOe1WPLAp2dqT3J4T67QHs6QbP0tyXGGJy+6ndZj/oD0Fsf",
  render_errors: [view: EcomWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Ecom.PubSub,
  live_view: [signing_salt: "qJUOeYP0"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
