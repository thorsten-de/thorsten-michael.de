defmodule TmdeWeb.ComponentHelpers do
  @moduledoc """
  Some helper functions to building components. Included with TmdeWeb, :component
  """
  import Phoenix.LiveView, only: [assign_new: 3, assign: 3]
  import Phoenix.LiveView.Helpers, only: [assigns_to_attributes: 2]
  import Tmde.Content.Translation, only: [translate: 2]

  @doc """
  Defines default variables for assigns
  """
  def assign_defaults(assigns, definitions \\ []) do
    definitions
    |> Enum.reduce(assigns, &init/2)
  end

  defp init({key, fun}, assigns) when is_function(fun, 0), do: assigns |> assign_new(key, fun)
  defp init({key, value}, assigns), do: init({key, fn -> value end}, assigns)

  @doc """
  Excludes assigns that should be used internally only and assigns the rest to @attributes
  """
  def set_attributes_from_assigns(assigns, exclude \\ []) do
    assigns
    |> assign(:attributes, assigns_to_attributes(assigns, exclude))
  end

  def translate_html(content) do
    locale = Gettext.get_locale(TmdeWeb.Gettext)

    content |> translate(locale) |> Phoenix.HTML.raw()
  end
end
