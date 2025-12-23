# lib/user_management/accounts.ex
defmodule UserManagement.Accounts do
  import Ecto.Query
  alias UserManagement.Repo
  alias UserManagement.Accounts.User

  def list_users(params \\ %{}) do
    # Podstawowe zapytanie z filtrami
    base_query =
      User
      |> filter_by_name(params["first_name"])
      |> filter_by_last_name(params["last_name"])
      |> filter_by_gender(params["gender"])
      |> filter_by_birthdate(params["birthdate_from"], params["birthdate_to"])

    # 1. Liczymy wszystkich pasujących (bez limitu i offsetu)
    total_count = Repo.aggregate(base_query, :count)

    # 2. Pobieramy konkretną stronę danych
    page = String.to_integer(params["page"] || "1")
    page_size = String.to_integer(params["page_size"] || "20")
    offset = (page - 1) * page_size

    entries =
      base_query
      |> order_by_params(params["sort_by"], params["sort_order"])
      |> limit(^page_size)
      |> offset(^offset)
      |> Repo.all()

    # Zwracamy strukturę z metadanymi
    %{
      entries: entries,
      total_count: total_count,
      page: page,
      page_size: page_size,
      total_pages: ceil(total_count / page_size)
    }
  end

  # Funkcje CRUD
  def get_user!(id), do: Repo.get!(User, id)

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  # --- Filtry (takie jak poprzednio) ---
  defp filter_by_name(q, name) when name in [nil, ""], do: q
  defp filter_by_name(q, name), do: where(q, [u], ilike(u.first_name, ^"%#{name}%"))

  defp filter_by_last_name(q, last), do: (if last in [nil, ""], do: q, else: where(q, [u], ilike(u.last_name, ^"%#{last}%")))

  defp filter_by_gender(q, g) when g in [nil, ""], do: q
  defp filter_by_gender(q, g), do: where(q, [u], u.gender == ^g)

  defp filter_by_birthdate(q, from, to) do
    q |> maybe_date(from, :>=) |> maybe_date(to, :<=)
  end

  defp maybe_date(q, date, _op) when date in [nil, ""], do: q
  defp maybe_date(q, date, :>=), do: where(q, [u], u.birthdate >= ^date)
  defp maybe_date(q, date, :<=), do: where(q, [u], u.birthdate <= ^date)

  defp order_by_params(query, sort_by, sort_order) do

    order = if sort_order == "desc", do: :desc, else: :asc

    # Mapujemy dopuszczalne pola, aby zapobiec SQL Injection
    field = case sort_by do
      "first_name" -> :first_name
      "last_name"  -> :last_name
      "birthdate"  -> :birthdate
      _            -> :id
    end

    order_by(query, [u], [{^order, ^field}])
  end
end
