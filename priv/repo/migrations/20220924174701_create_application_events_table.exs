defmodule Tmde.Repo.Migrations.CreateApplicationEventsTable do
  use Ecto.Migration

  def change do
    create table(:job_application_events) do
      add :application_id, references(:job_applications), null: false
      add :type, :string, null: false
      add :payload, :map
      timestamps()
    end

    create index(:job_application_events, :application_id)
  end
end
