import Config

# Konfiguracja bazy danych dla deweloperki
config :user_management, UserManagement.Repo,
  username: System.get_env("DB_USER") || "postgres",
  password: System.get_env("DB_PASSWORD") || "password",
  hostname: System.get_env("DB_HOST") || "localhost",
  database: System.get_env("DB_NAME") || "my_app_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# Konfiguracja Endpointa (Phoenix)
config :user_management, UserManagementWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: 4000], # Bind do 0.0.0.0 dla Dockera
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "TWOJ_BARDZO_DLUGI_SECRET_DLA_DEV",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:user_management, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:user_management, ~w(--watch)]}
  ]

# Inne ustawienia
config :user_management, UserManagement.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/use_management_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

config :logger, :console, format: "[$level] $message\n"
config :phoenix, :stacktrace_depth, 20
config :phoenix, :plug_init_mode, :runtime
