defmodule Tmde.Content do
  import Ecto.Query
  alias Tmde.Repo

  alias __MODULE__.Translation

  def remove_translation(data, translation_field, id) do
    data
    |> Translation.remove_translation_changeset(translation_field, id)
    |> Repo.update()
  end
end
