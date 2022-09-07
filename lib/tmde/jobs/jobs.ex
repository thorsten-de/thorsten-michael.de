defmodule Tmde.Jobs do
  @moduledoc """
  Context for applications and jobs
  """
  alias Tmde.Jobs.{Skill, JobSeeker}
  alias Tmde.Repo
  import Ecto.Query
  import Ecto

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

  @spec get_job_seeker!(any) :: nil | [%{optional(atom) => any}] | %{optional(atom) => any}
  def get_job_seeker!(id) do
    JobSeeker
    |> Repo.get!(id)
  end

  def job_seeker_languages(%JobSeeker{} = seeker) do
    Repo.all(
      from ps in assoc(seeker, :skills),
        join: s in assoc(ps, :skill),
        where: s.type == :language,
        preload: [skill: s]
    )
  end
end
