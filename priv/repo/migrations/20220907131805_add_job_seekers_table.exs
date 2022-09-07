defmodule Tmde.Repo.Migrations.AddJobSeekersTable do
  use Ecto.Migration

  def change do
    create table(:job_seekers) do
      add :contact, :map
      add :links, :map

      timestamps()
    end
  end
end
