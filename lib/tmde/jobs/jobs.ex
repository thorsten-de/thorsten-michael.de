defmodule Tmde.Jobs do
  @moduledoc """
  Context for applications and jobs
  """
  alias Tmde.Jobs.{Skill, JobSeeker}
  alias Tmde.Repo

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
end
