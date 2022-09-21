defmodule Tmde.Jobs.PersonalSkill do
  @moduledoc """
  Connects skills to JobSeekers
  """
  use Tmde, :schema
  alias Tmde.Jobs.{JobSeeker, Skill}

  @categories [default: 0, languages: 1, featured: 2, prog_langs: 3, techs: 4]

  schema "personal_skills" do
    field :sort_order, :integer, default: 0
    field :rating, :integer

    field :category, Ecto.Enum,
      values: @categories,
      default: :default

    field :is_featured, :boolean, default: false

    belongs_to :job_seeker, JobSeeker
    belongs_to :skill, Skill

    embeds_many :description, Translation
    embeds_many :rating_text, Translation

    timestamps()
  end

  def changeset(skill, attr \\ %{}) do
    skill
    |> cast(attr, [:sort_order, :rating, :job_seeker_id, :category, :is_featured, :skill_id])
    |> Translation.cast_translation(:description)
    |> Translation.cast_translation(:rating_text)
  end

  import TmdeWeb.Gettext
  def category_label(:languages), do: gettext("Languages")
  def category_label(:featured), do: gettext("Primary Skills")
  def category_label(:prog_langs), do: gettext("Programming Languages")
  def category_label(:techs), do: gettext("Techs and Frameworks")
  def category_label(_), do: gettext("Skills")
end
