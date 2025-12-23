defmodule UserManagementWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :user_management

  # socket "/socket", UserManagementWeb.UserSocket,
  #   websocket: true,
  #   longpoll: false

  # Serve at "/" the static files from "priv/static" directory.
  # The directory is defined in "mix.exs" as "app: :user_management"
  plug Plug.Static,
    at: "/",
    from: :user_management,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  # If you enable code reloading, you must set :check_origin
  # to false or the server will reject all cross-origin requests.
  if code_reloading? do
    # socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    # plug Phoenix.LiveReloader
    # plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]
  plug Plug.Parsers, parsers: [:urlencoded, :multipart, :json],
                      pass: ["*/*"], json_decoder: Phoenix.json_library()
  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, store: :cookie, key: "_user_management_key", signing_salt: "change_me"

  plug UserManagementWeb.Router
end
