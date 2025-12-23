defmodule UserManagementWeb.Router do
  use UserManagementWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", UserManagementWeb do
    pipe_through :api
    resources "/users", UserController, except: [:new, :edit]
    post "/import", ImportController, :import
  end
end
