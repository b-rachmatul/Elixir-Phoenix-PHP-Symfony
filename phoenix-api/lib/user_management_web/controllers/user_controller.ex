defmodule UserManagementWeb.UserController do
  use UserManagementWeb, :controller

  alias UserManagement.Accounts
  alias UserManagement.Accounts.User

  # GET /api/users (z filtrami i paginacją)
  def index(conn, params) do
    pagination = Accounts.list_users(params)
    # Przekazujemy całą mapę 'pagination' do renderowania
    render(conn, :index, pagination: pagination)
  end

  # GET /api/users/:id
  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
  end

  # POST /api/users
  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", ~p"/api/users/#{user}")
        |> render(:show, user: user)

      {:error, changeset} ->
        render_error(conn, changeset)
    end
  end

  # PUT /api/users/:id
  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} -> render(conn, :show, user: user)
      {:error, changeset} -> render_error(conn, changeset)
    end
  end

  # DELETE /api/users/:id
  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  # Prywatna funkcja pomocnicza do błędów
  defp render_error(conn, changeset) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: UserManagementWeb.ChangesetJSON)
    |> render("error.json", changeset: changeset)
  end
end
