defmodule TmdeWeb.Components.ContentComponents do
  @moduledoc """
  Components to work with translated content
  """

  use TmdeWeb, :component

  def t(assigns) do
    ~H"""
      <%= translate(assigns) %>
    """
  end
end
