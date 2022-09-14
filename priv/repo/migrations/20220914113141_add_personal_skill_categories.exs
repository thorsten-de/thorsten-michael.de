defmodule Tmde.Repo.Migrations.AddPersonalSkillCategories do
  use Ecto.Migration

  def change do
    alter table(:personal_skills) do
      add :category, :integer, null: false, default: 0
      add :is_featured, :boolean, null: false, default: false
    end
  end
end
