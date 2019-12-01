use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :elixir_status, ElixirStatus.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :elixir_status, ElixirStatus.Repo,
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox,
  username: "postgres",
  password: "postgres",
  database: "elixir_status_test",
  # Use a single connection for transactional tests
  size: 1

config :elixir_status, :base_url, "http://test.local"
config :elixir_status, :admin_user_ids, [1234]

# This function receives the posting and author as arguments and determines
# reasons why it requires moderation
# Return an empty list if no moderation is necessary
config :elixir_status,
       :publisher_moderation_reasons,
       &ElixirStatusModerationSample.moderation_reasons/2

config :elixir_status, :publisher_blocked_urls, []
config :elixir_status, :publisher_blocked_user_names, []
