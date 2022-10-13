defmodule Tmde.Repo.Migrations.RemoveApplicationSubjectNotNull do
  use Ecto.Migration

  def up do
    execute("ALTER TABLE job_applications ALTER COLUMN subject DROP NOT NULL;")
  end

  def down do
  end
end
