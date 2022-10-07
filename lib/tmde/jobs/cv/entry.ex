defmodule Tmde.Jobs.CV.Entry do
  @moduledoc """
  CV.Entry models an entry in your CV and can be a job experience or
  part of your educational history. It covers information about the
  time of your experience, your role/position and the company/school.
  It consists of a list of focus points to highlight your experience
  in a structural manner.
  """
  use Tmde, :schema
  alias Tmde.Jobs.{CV, JobSeeker}
  alias Tmde.Content.Translation

  schema "cv_entries" do
    field :type, Ecto.Enum, values: [:job, :education, :projects]
    field :from, :date
    field :until, :date
    field :sort_order, :integer
    field :icon, :string

    translation_field(:role)
    translation_field(:description)

    embeds_one :company, Company do
      field :name, :string
      field :location, :string
      translation_field(:sector)
    end

    belongs_to :job_seeker, JobSeeker

    has_many :focuses, CV.Focus

    timestamps()
  end

  def _changeset(entry, params \\ %{}) do
    entry
    |> cast(params, [:type, :from, :until, :sort_order, :icon])
    |> cast_embed(:company)
    |> Translation.cast_translation(:role)
    |> Translation.cast_translation(:description)
    |> cast_embed(:company)
    |> cast_assoc(:focuses)
  end
end
