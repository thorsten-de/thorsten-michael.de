defmodule Tmde.Repo.Migrations.AddCvEntriesTable do
  use Ecto.Migration

  def change do
    create table(:cv_entries) do
      add :type, :string, null: false, length: 12
      add :from, :date
      add :until, :date
      add :sort_order, :integer, null: false, default: 0
      add :icon, :string

      add :role, :map
      add :description, :map
      add :company, :map

      add :job_seeker_id, references(:job_seekers), null: false

      timestamps()
    end

    create index(:cv_entries, :job_seeker_id)
  end
end
