defmodule Tmde.Repo.Migrations.AddCompanyToApplication do
  use Ecto.Migration

  def change do
    alter table(:job_applications) do
      add :company, :string
    end
  end
end
