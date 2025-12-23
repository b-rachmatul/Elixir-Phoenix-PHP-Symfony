defmodule UserManagementWeb.ImportController do
  use UserManagementWeb, :controller
  alias UserManagement.Importer

  def import(conn, _params) do
    case Importer.import_users() do
      :ok -> 
        send_resp(conn, 200, "Users imported successfully")
      {:error, reason} -> 
        send_resp(conn, 400, "Failed to import users: #{reason}")
    end
  end
end