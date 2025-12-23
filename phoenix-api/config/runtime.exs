import Config

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise "environment variable DATABASE_URL is missing."

  config :user_management, UserManagement.Repo,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise "environment variable SECRET_KEY_BASE is missing."

  host = System.get_env("PHX_HOST") || "localhost"

  config :user_management, UserManagementWeb.Endpoint,
    server: true,
    url: [host: host, port: 4000, scheme: "http"],
    http: [
      ip: {0, 0, 0, 0},
      port: 4000
    ],
    secret_key_base: secret_key_base
end
