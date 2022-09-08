defmodule Tmde.Jobs.Skill do
  @moduledoc """
  A general skill that can be connected to job_seekers and used in CVs
  """
  use Tmde, :schema

  schema "skills" do
    field :type, Ecto.Enum, values: [:language, :profession, :character], default: :profession
    field :icon, :string
    field :name, :string
    embeds_many :label, Translation

    timestamps()
  end

  def changeset(skill, attr \\ %{}) do
    skill
    |> cast(attr, [:type, :icon, :name])
    |> unique_constraint(:name)
    |> Translation.cast_translation(:label, infer_from: :name)
  end

  def with_type(query, type) do
    from s in query,
      where: [type: ^type]
  end
end
