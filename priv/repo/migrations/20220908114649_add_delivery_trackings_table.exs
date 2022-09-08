defmodule Tmde.Repo.Migrations.AddDeliveryTrackingsTable do
  use Ecto.Migration

  def change do
    create table(:delivery_trackings) do
      add :delivery_id, references(:deliveries), null: false
      add :payload, :map
      timestamps()
    end

    create index(:delivery_trackings, :delivery_id)
  end
end
