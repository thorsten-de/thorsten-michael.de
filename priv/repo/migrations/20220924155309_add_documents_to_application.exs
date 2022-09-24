defmodule Tmde.Repo.Migrations.AddDocumentsToApplication do
  use Ecto.Migration

  def change do
    alter table(:job_applications) do
      add :documents, :map
    end
  end
end
