# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :tutorial_auth,
  ecto_repos: [TutorialAuth.Repo]

# Configures the endpoint
config :tutorial_auth, TutorialAuthWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "FL1X2BP9C64gRJ/SWWaU+Gjyfwtzfn6y4dIdKo5a9gGcg5IlHdkR+fGNRfMHYeDu",
  render_errors: [view: TutorialAuthWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: TutorialAuth.PubSub,
  live_view: [signing_salt: "OChdxDbd"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
