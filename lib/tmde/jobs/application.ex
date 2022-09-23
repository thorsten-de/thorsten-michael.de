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
    field :company, :string
    field :locale, Ecto.Enum, values: [:de, :en], default: :de
    embeds_one :contact, Contact
    embeds_many :cover_letter, Translation
    embeds_many :cover_email, Translation

    belongs_to :job_seeker, JobSeeker
    has_many :cv_entries, CV.Entry
    has_many :skills, through: [:job_seeker, :skills]
    timestamps()
  end

  @max_token_age 86400 * 365
  def sign_token(%__MODULE__{id: id}) do
    Phoenix.Token.sign(TmdeWeb.Endpoint, "job_application", Ecto.UUID.dump!(id),
      max_age: @max_token_age
    )
  end

  def token_to_id(token) do
    with {:ok, uuid} <- Phoenix.Token.verify(TmdeWeb.Endpoint, "job_application", token),
         {:ok, id} <- Ecto.UUID.load(uuid) do
      {:ok, id}
    end
  end
end
