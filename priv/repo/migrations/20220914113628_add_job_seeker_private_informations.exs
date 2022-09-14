defmodule Tmde.Repo.Migrations.AddJobSeekerPrivateInformations do
  use Ecto.Migration

  def change do
    alter table(:job_seekers) do
      add :dob, :date
      add :place_of_birth, :string
      add :citizenship, :string
      add :marital_status, :string

      add :slogan, :map
    end
  end
end
