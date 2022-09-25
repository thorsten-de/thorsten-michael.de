defmodule Tmde.Jobs.JobSeeker do
  @moduledoc """
  A job seeker who can apply for jobs. My personal data resides in that table.
  """
  use Tmde, :schema
  alias Tmde.Contacts.{Contact, Link}
  alias Tmde.Jobs.{Application, PersonalSkill}

  schema "job_seekers" do
    field :dob, :date
    field :place_of_birth, :string
    field :citizenship, :string
    field :marital_status, Ecto.Enum, values: [:single, :married, :devorced, :widowed]

    embeds_one :contact, Contact
    embeds_many :links, Link
    embeds_many :slogan, Translation

    has_many :skills, PersonalSkill
    has_many :applications, Application

    timestamps()
  end

  def changeset(job_seeker, attr \\ %{}) do
    job_seeker
    |> cast(attr, [:dob, :place_of_birth, :citizenship, :marital_status])
    |> cast_embed(:contact, required: true)
    |> cast_embed(:links)
    |> Translation.cast_translation(:slogan)
    |> cast_assoc(:skills)
  end

  def skill_query(%__MODULE__{} = job_seeker) do
    from ps in assoc(job_seeker, :skills),
      join: s in assoc(ps, :skill),
      preload: [skill: s]
  end
end
