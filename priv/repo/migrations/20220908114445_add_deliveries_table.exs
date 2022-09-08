defmodule Tmde.Repo.Migrations.AddDeliveriesTable do
  use Ecto.Migration

  def change do
    create table(:deliveries) do
      add :email, :string
      add :subject, :string
      add :application_id, references(:job_applications)
      timestamps()
    end

    create index(:deliveries, :application_id)
  end
end
