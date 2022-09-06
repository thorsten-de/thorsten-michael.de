defmodule Tmde.Jobs.Application do
  @moduledoc """
  A job application
  """
  use Ecto.Schema
  alias Tmde.Contacts.Contact
  alias Tmde.Jobs.JobSeeker

  schema "job_applications" do
    field :subject, :string
    belongs_to :job_seeker, JobSeeker
    embeds_one :sender, Contact
  end
end
