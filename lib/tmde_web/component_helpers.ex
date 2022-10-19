defmodule TmdeWeb.ComponentHelpers do
  @moduledoc """
  Some helper functions to building components. Included with TmdeWeb, :component
  """
  alias Tmde.Content.Translation
  import Phoenix.Component, only: [update: 3]

  def translate(content) do
    locale = Gettext.get_locale(TmdeWeb.Gettext)

    content
    |> Translation.translate(locale)
  end

  def toggle(socket, key),
    do: update(socket, key, &(!&1))
end
