defmodule UserManagement.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @available_genders [:male, :female]

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :birthdate, :date
    field :gender, Ecto.Enum, values: @available_genders

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :birthdate, :gender])
    |> validate_required([:first_name, :last_name, :birthdate, :gender])
    |> validate_inclusion(:gender, @available_genders)
  end
end
