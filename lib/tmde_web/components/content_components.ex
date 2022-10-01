defmodule TmdeWeb.Components.ContentComponents do
  @moduledoc """
  Components to work with translated content
  """

  use TmdeWeb, :component

  def t(%{html: html} = assigns) do
    ~H"""
      <%= translate(@html) %>
    """
  end

  def t(assigns) do
    ~H"""
      <%= translate(@content) %>
    """
  end
end
