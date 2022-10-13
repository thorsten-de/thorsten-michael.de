defmodule Tmde.Jobs do
  @moduledoc """
  Context for applications and jobs
  """
  alias Tmde.Jobs.{Application, Skill, JobSeeker, Delivery, CV, PersonalSkill}
  alias Tmde.Contacts.Contact
  alias Tmde.Repo
  import Ecto.Query
  import Ecto

  import TmdeWeb.Gettext

  def get_cv(job_seeker) do
    job_seeker
    |> Repo.preload(cv_entries: {ordered(CV.Entry), focuses: ordered(CV.Focus)})
    |> Map.get(:cv_entries)
    |> Enum.group_by(& &1.type)
  end

  def get_application!(id) do
    if function_exported?(Private, :get_application, 0) do
      # TODO: Use full featured DB approach
      # For building out functionality, I can include a module with private application
      # data inside IEX. Will be removed when a full featured Application DB is in place.
      Private.get_application()
    else
      Application
      |> Repo.get!(id)
      |> Repo.preload(
        job_seeker: [
          skills: {ordered(PersonalSkill), skill: []},
          cv_entries: {ordered(CV.Entry), focuses: ordered(CV.Focus)}
        ]
      )
    end
  end

  def change_application(application, params \\ %{}) do
    application
    |> Application.changeset(params)
  end

  def insert_or_update_application(application, params) do
    application
    |> change_application(params)
    |> Repo.insert_or_update()
  end

  def new_application(job_seeker, params \\ %{}) do
    Application
    |> struct!(
      Map.merge(
        %{
          job_seeker: job_seeker,
          company: gettext("Company"),
          contact: %Contact{}
        },
        params
      )
    )
  end

  def job_seeker_applications(job_seeker) do
    from(a in assoc(job_seeker, :applications), order_by: [desc: a.inserted_at])
    |> Repo.all()
  end

  def update_documents(application, documents) do
    application
    |> Application.put_documents(documents)
    |> Repo.update()
  end

  def log_event!(%Application{} = application, type, payload \\ %{}) do
    application
    |> Ecto.build_assoc(:events, %{type: type, payload: payload})
    |> Repo.insert!()
  end

  def change_job_seeker(job_seeker, params \\ %{}) do
    job_seeker
    |> JobSeeker.changeset(params)
  end

  def update_job_seeker(job_seeker, params) do
    job_seeker
    |> change_job_seeker(params)
    |> Repo.update()
  end

  def change_cv_entry(entry, params \\ %{}) do
    entry
    |> CV.Entry.changeset(params)
  end

  def update_cv_entry(entry, params \\ %{}) do
    entry
    |> change_cv_entry(params)
    |> Repo.update()
  end

  @doc """
  Creates a new skill with given attributes
  """
  def create_skill(attributes) do
    %Skill{}
    |> Skill.changeset(attributes)
    |> Repo.insert()
  end

  def languages(%JobSeeker{} = seeker) do
    seeker
    |> JobSeeker.skill_query()
    |> Skill.with_type(:language)
    |> Repo.all()
  end

  def all_skills(%JobSeeker{} = seeker) do
    seeker
    |> JobSeeker.skill_query()
    |> Repo.all()
  end

  def create_delivery(application \\ nil, attrs \\ %{}) do
    application
    |> Delivery.create_changeset(attrs)
    |> Repo.insert()
  end

  def get_delivery(id) do
    Delivery
    |> Repo.get(id)
  end

  def create_delivery_tracking(%Delivery{} = delivery, attr \\ %{}) do
    delivery
    |> Ecto.build_assoc(:trackings, attr)
    |> Repo.insert()
  end

  defp ordered(query, order \\ [asc: :sort_order]) do
    from q in query, order_by: ^order
  end
end
