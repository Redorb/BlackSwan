defmodule BlackSwan.Repo.Migrations.CreateOrganization do
  use Ecto.Migration

  def change do
    create table(:organizations) do
      add :name, :string
      add :description, :string

      timestamps()
    end

  end
end
