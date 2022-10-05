defmodule Tmde.Contacts do
  @moduledoc """
  Contacts Context menu
  """
  import Ecto.Changeset
  alias Tmde.Repo

  def change_contact(obj, field, params \\ %{}) do
    obj
    |> cast(params, [])
    |> cast_embed(field)
  end

  def update_contact(obj, field, params) do
    obj
    |> change_contact(field, params)
    |> Repo.update()
  end
end
