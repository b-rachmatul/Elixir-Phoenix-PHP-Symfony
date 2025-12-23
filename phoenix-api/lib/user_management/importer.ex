defmodule UserManagement.Importer do
  alias UserManagement.Repo
  alias UserManagement.Accounts.User

  @male_names ["Jan", "Marek", "Adam", "Paweł", "Piotr", "Krzysztof"]
  @female_names ["Anna", "Maria", "Katarzyna", "Monika", "Agata", "Ewa"]
  @last_names ["Kowalski", "Nowak", "Wiśniewski", "Wójcik", "Kamiński", "Lewandowski"]

  def import_users do
    1..100
    |> Enum.each(fn _ ->
      gender = Enum.random([:male, :female])

      first_name = case gender do
        :male -> Enum.random(@male_names)
        :female -> Enum.random(@female_names)
      end
      last_name = Enum.random(@last_names)
      birthdate = generate_random_birthdate()

      %User{}
      |> User.changeset(%{
        first_name: first_name,
        last_name: last_name,
        birthdate: birthdate,
        gender: gender
      })
      |> Repo.insert()
    end)
  end

  def generate_random_birthdate do
    start_date = ~D[1970-01-01]
    end_date = ~D[2024-12-31]
    days_diff = Date.diff(end_date, start_date)

    start_date
    |> Date.add(:rand.uniform(days_diff))
  end
end
