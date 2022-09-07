defmodule Tmde.Jobs.Application do
  @moduledoc """
  A job application
  """
  use Tmde, :schema
  alias Tmde.Contacts.Contact
  alias Tmde.Jobs.{CV, JobSeeker}

  schema "job_applications" do
    field :subject, :string
    field :reference, :string
    embeds_one :sender, Contact
    embeds_many :cover_letter, Translation
    embeds_many :cover_email, Translation

    belongs_to :job_seeker, JobSeeker
    has_many :cv_entries, CV.Entry
    has_many :skills, through: [:job_seeker, :skills]
  end
end
