defmodule Tmde.Repo.Migrations.AddCvFocusesTable do
  use Ecto.Migration

  def change do
    create table(:cv_focuses) do
      add :url, :string
      add :sort_order, :integer, null: false, default: 0

      add :entry_id, references(:cv_entries), null: false
      add :abstract, :map
      timestamps()
    end
  end
end
