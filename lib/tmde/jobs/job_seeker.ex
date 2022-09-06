defmodule Tmde.Jobs.JobSeeker do
  @moduledoc """
  A job seeker who can apply for jobs. My personal data resides in that table.
  """

  use Ecto.Schema
  alias Tmde.Contacts.{Contact, Link}

  schema "job_seekers" do
    embeds_one :contact, Contact
    embeds_many :links, Link
  end
end
