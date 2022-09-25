defmodule Tmde.Repo.Migrations.AddLoginCredentialsToJobSeeker do
  use Ecto.Migration

  def change do
    alter table(:job_seekers) do
      add :username, :string
      add :password_hash, :string
    end

    create index(:job_seekers, :username)
  end
end
