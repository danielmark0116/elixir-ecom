use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :server, Ecom.Repo,
  username: "postgres",
  password: "postgres",
  database: "server_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :server, EcomWeb.Endpoint,
  http: [port: 4002],
  server: false

if System.get_env("GITHUB_ACTIONS") do
  config :server, Ecom.Repo,
    username: "postgres",
    password: "postgres",
    database: "test_db"
end

# Print only warnings and errors during test
config :logger, level: :warn

config :server, :environment, :test
