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

    translation_field(:slogan)

    has_many :skills, PersonalSkill
    has_many :applications, Application

    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string

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

  def login_changeset(job_seeker, attr) do
    job_seeker
    |> cast(attr, [:username, :password])
    |> validate_required([:username, :password])
    |> validate_length(:password, min: 6, max: 20)
    |> put_password_hash()
  end

  defp put_password_hash(cs) do
    case cs do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(cs, :password_hash, Pbkdf2.hash_pwd_salt(pass))

      _ ->
        cs
    end
  end

  def skill_query(%__MODULE__{} = job_seeker) do
    from ps in assoc(job_seeker, :skills),
      join: s in assoc(ps, :skill),
      preload: [skill: s]
  end

  defimpl String.Chars, for: __MODULE__ do
    def to_string(%{username: username}), do: username
  end

  defimpl Phoenix.HTML.Safe, for: __MODULE__ do
    def to_iodata(job_seeker), do: to_string(job_seeker)
  end
end
