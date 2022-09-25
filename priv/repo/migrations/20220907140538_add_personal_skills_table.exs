defmodule Tmde.Repo.Migrations.AddPersonalSkillsTable do
  use Ecto.Migration

  def change do
    create table(:personal_skills) do
      add :sort_order, :integer, null: false, default: 0
      add :rating, :integer
      add :job_seeker_id, references(:job_seekers), null: false
      add :skill_id, references(:skills), null: false
      add :description, :map
      add :rating_text, :map

      timestamps()
    end

    create index(:personal_skills, [:job_seeker_id])
    create unique_index(:personal_skills, [:job_seeker_id, :skill_id])
  end
end
