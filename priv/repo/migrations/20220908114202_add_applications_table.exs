defmodule Tmde.Repo.Migrations.AddApplicationsTable do
  use Ecto.Migration

  def change do
    create table(:job_applications) do
      add :subject, :string, null: false
      add :reference, :string
      add :locale, :string, length: 4
      add :contact, :map
      add :cover_letter, :map
      add :cover_email, :map

      add :job_seeker_id, references(:job_seekers), null: false
      timestamps()
    end

    create index(:job_applications, :job_seeker_id)
  end
end
