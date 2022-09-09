defmodule Tmde.Jobs do
  @moduledoc """
  Context for applications and jobs
  """
  alias Tmde.Jobs.{Skill, JobSeeker, Delivery}
  alias Tmde.Repo

  def get_application!(id) do
    Private.get_application()
    # Application
    # |> Repo.get!(id)
  end

  @doc """
  Creates a new skill with given attributes
  """
  def create_skill(attributes) do
    %Skill{}
    |> Skill.changeset(attributes)
    |> Repo.insert()
  end

  def create_job_seeker(attributes) do
    %JobSeeker{}
    |> JobSeeker.changeset(attributes)
    |> Repo.insert()
  end

  def get_job_seeker!(id) do
    JobSeeker
    |> Repo.get!(id)
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
end
