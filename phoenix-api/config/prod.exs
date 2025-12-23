import Config

# Logowanie ustawione na debug
config :logger, level: :debug

config :user_management, UserManagementWeb.Endpoint,
  # To pozwala na generowanie linków,
  # ale porty i IP zostaną nadpisane przez runtime.exs
  url: [host: "localhost", port: 4000]
