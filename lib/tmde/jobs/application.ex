defmodule Tmde.Jobs.Application do
  @moduledoc """
  A job application
  """
  use Tmde, :schema
  import Ecto.Changeset
  alias Tmde.Contacts.Contact
  alias Tmde.Jobs.{CV, JobSeeker, ApplicationEvent}

  schema "job_applications" do
    field :subject, :string
    field :reference, :string
    field :short_reference, :string
    field :company, :string
    field :locale, Ecto.Enum, values: [:de, :en], default: :de
    embeds_one :contact, Contact
    embeds_many :cover_letter, Translation
    embeds_many :cover_email, Translation

    embeds_many :documents, Document, on_replace: :delete do
      field :slug, :string
      field :label, :string
      field :filename, :string
    end

    belongs_to :job_seeker, JobSeeker
    has_many :cv_entries, CV.Entry
    has_many :skills, through: [:job_seeker, :skills]

    has_many :events, ApplicationEvent
    timestamps()
  end

  def put_documents(%__MODULE__{} = application, documents) do
    application
    |> change()
    |> put_embed(:documents, documents)
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
