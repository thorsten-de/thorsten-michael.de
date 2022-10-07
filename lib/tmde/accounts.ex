defmodule Tmde.Accounts do
  @moduledoc """
  Context for authenticating Users (JobSeekers)
  """

  alias Tmde.Jobs.JobSeeker
  alias Tmde.Repo

  def create_login(job_seeker, username, password) do
    job_seeker
    |> JobSeeker.login_changeset(%{username: username, password: password})
    |> Repo.update()
  end

  def authenticate(username, password) do
    user =
      JobSeeker
      |> Repo.get_by(username: username)

    cond do
      user && Pbkdf2.verify_pass(password, user.password_hash) ->
        {:ok, user}

      user ->
        {:error, :unauthorized}

      true ->
        Pbkdf2.no_user_verify()
        {:error, :not_found}
    end
  end

  def get_user(id) do
    JobSeeker
    |> Repo.get(id)
  end

  def create_user(attributes, cv_entries) do
    %JobSeeker{}
    |> JobSeeker.changeset(attributes)
    |> Ecto.Changeset.put_assoc(:cv_entries, cv_entries)
    |> Repo.insert()
  end
end
