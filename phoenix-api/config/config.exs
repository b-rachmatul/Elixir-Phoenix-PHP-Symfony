import Config

# Konfiguracja bazy danych (podstawowa)
config :user_management,
  ecto_repos: [UserManagement.Repo]

# Konfiguracja Endpointa (podstawowa)
config :user_management, UserManagementWeb.Endpoint,
  render_errors: [
    formats: [json: UserManagementWeb.ErrorJSON],
    accepts: ~w(json)
  ],
  pubsub_server: UserManagement.PubSub,
  live_view: [signing_salt: "super_dowolny_ciąg_znaków"],
  adapter: Phoenix.Endpoint.Cowboy2Adapter

# Konfiguracja Loggera
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Użycie JSON do logowania w Phoenix
config :phoenix, :json_library, Jason

# NA KOŃCU: Importowanie konfiguracji zależnej od środowiska (dev.exs / prod.exs)
import_config "#{config_env()}.exs"
