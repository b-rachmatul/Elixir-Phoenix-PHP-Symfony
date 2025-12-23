defmodule UserManagementWeb.UserJSON do
  def index(%{pagination: pagination}) do
    %{
      data: for(user <- pagination.entries, do: data(user)),
      meta: %{
        total_count: pagination.total_count,
        page: pagination.page,
        page_size: pagination.page_size,
        total_pages: pagination.total_pages
      }
    }
  end

  def show(%{user: user}) do
    %{data: data(user)}
  end

  defp data(user) do
    %{
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      gender: user.gender,
      birthdate: user.birthdate
    }
  end
end
