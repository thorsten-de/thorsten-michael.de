defmodule Tmde.Content do
  import Ecto.Query
  import Ecto.Changeset
  alias Tmde.Repo

  alias __MODULE__.Translation

  def all_locales do
    Gettext.known_locales(TmdeWeb.Gettext)
  end

  def remove_translation(data, translation_field, id) do
    data
    |> Translation.remove_translation_changeset(translation_field, id)
    |> Repo.update()
  end

  def add_translation(data, translation_field, params \\ %{}) do
    data
    |> Translation.add_translation_changeset(translation_field, params)
    |> Repo.update()
  end

  def change_translations(data, translation_field, params \\ %{}) do
    data
    |> cast(params, [])
    |> cast_embed(translation_field)
  end

  def update_translations(data, translation_field, params) do
    data
    |> change_translations(translation_field, params)
    |> Repo.update()
  end
end
