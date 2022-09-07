defmodule Tmde.Jobs do
  @moduledoc """
  Context for applications and jobs
  """
  alias Tmde.Jobs.Skill
  alias Tmde.Repo

  @doc """
  Creates a new skill with given attributes
  """
  def create_skill(attributes) do
    %Skill{}
    |> Skill.changeset(attributes)
    |> Repo.insert()
  end
end
