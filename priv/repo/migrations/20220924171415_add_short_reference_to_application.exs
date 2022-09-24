defmodule Tmde.Repo.Migrations.AddShortReferenceToApplication do
  use Ecto.Migration

  def change do
    alter table(:job_applications) do
      add :short_reference, :string
    end
  end
end
