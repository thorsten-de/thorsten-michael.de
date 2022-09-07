defmodule Tmde.Repo.Migrations.AddSkillsTable do
  use Ecto.Migration

  def change do
    create table(:skills) do
      add :type, :string, size: 20, null: false
      add :name, :string, null: false
      add :icon, :string
      add :label, :map

      timestamps()
    end

    create unique_index(:skills, [:name])
  end
end
