defmodule Tmde.Repo.Migrations.ChangeApplicationStringsToTranslations do
  use Ecto.Migration

  def up do
    execute("UPDATE job_applications SET subject='[]', reference='[]';")

    execute(
      "ALTER TABLE job_applications ALTER COLUMN subject SET DATA TYPE jsonb USING subject::jsonb;"
    )

    execute(
      "ALTER TABLE job_applications ALTER COLUMN reference SET DATA TYPE jsonb USING reference::jsonb;"
    )
  end

  def down do
  end
end
