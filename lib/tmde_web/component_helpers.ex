defmodule TmdeWeb.ComponentHelpers do
  @moduledoc """
  Some helper functions to building components. Included with TmdeWeb, :component
  """
  alias Tmde.Content.Translation

  def translate_html(content) do
    content
    |> translate()
    |> Phoenix.HTML.raw()
  end

  def translate(content) do
    locale = Gettext.get_locale(TmdeWeb.Gettext)

    content
    |> Translation.translate(locale)
  end
end
