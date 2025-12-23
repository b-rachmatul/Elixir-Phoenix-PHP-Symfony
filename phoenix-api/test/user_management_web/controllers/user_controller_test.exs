defmodule UserManagementWeb.UserControllerTest do
  use UserManagementWeb.ConnCase

  alias UserManagement.Accounts
  alias UserManagement.Accounts.User

  @create_attrs %{
    first_name: "Adam",
    last_name: "Dobry",
    gender: "male",
    birthdate: ~D[1990-01-01]
  }

  def user_fixture(attrs \\ %{}) do
    {:ok, user} = attrs |> Enum.into(@create_attrs) |> Accounts.create_user()
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users and applies filters", %{conn: conn} do
      user_fixture(%{first_name: "Zenon", gender: "male"})
      user_fixture(%{first_name: "Anna", gender: "female"})

      # Test filtrowania po płci
      conn_filtered = get(conn, ~p"/api/users", %{"gender" => "female"})
      assert json_response(conn_filtered, 200)["data"] |> length() == 1
      assert hd(json_response(conn_filtered, 200)["data"])["first_name"] == "Anna"

      # Test sortowania
      conn_sorted = get(conn, ~p"/api/users", %{"sort_by" => "first_name", "sort_order" => "asc"})
      names = Enum.map(json_response(conn_sorted, 200)["data"], & &1["first_name"])
      assert names == ["Anna", "Zenon"]
    end
  end

  describe "update user" do
    test "renders user when data is valid", %{conn: conn} do
      user = user_fixture()
      conn = put(conn, ~p"/api/users/#{user}", user: %{first_name: "Marek"})
      assert %{"id" => id} = json_response(conn, 200)["data"]

      updated_user = Accounts.get_user!(id)
      assert updated_user.first_name == "Marek"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = user_fixture()
      conn = put(conn, ~p"/api/users/#{user}", user: %{first_name: nil})
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
