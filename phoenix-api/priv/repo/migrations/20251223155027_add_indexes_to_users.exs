defmodule UserManagement.Repo.Migrations.AddIndexesToUsers do
  use Ecto.Migration

  def change do
    # Indeks B-tree dla nazwiska (najczęstsze filtrowanie)
    create index(:users, [:last_name])

    # Indeks dla daty urodzenia (przyspiesza filtrowanie od-do i sortowanie)
    create index(:users, [:birthdate])

    # Opcjonalnie: Indeks trójgramowy (trigram) dla imienia i nazwiska,
    # jeśli chcesz, aby ilike '%tekst%' działało bardzo szybko.
    # Wymaga rozszerzenia pg_trgm w Postgresie.
    execute "CREATE EXTENSION IF NOT EXISTS pg_trgm"
    execute "CREATE INDEX users_first_name_trgm_index ON users USING gin (first_name gin_trgm_ops)"
    execute "CREATE INDEX users_last_name_trgm_index ON users USING gin (last_name gin_trgm_ops)"
  end
end
