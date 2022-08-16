defmodule TmdeWeb.Plugs.Page do
  @moduledoc """
  Plug that handles metadata for pages
  """

  import Plug.Conn

  defstruct locale: "de",
            author: "",
            description: ""

  @doc """
  Sets the default metadata to be used when plug is called in the pipeline
  """
  def init(options) do
    __MODULE__
    |> struct!(options)
  end

  @doc """
  Adds a %Page{} struct to conn assignments with key :page, so it is safe to use @page
  in all the templates (and layouts!) when Plugs.Page is part of the pipeline. Uses
  the defaults given to init/1, so it can configured inside the pipeline
  """
  def call(conn, options) do
    conn
    |> assign(:page, options)
  end

  @doc """
  Adds a :page_title to the conn assigns. Note that :page_title is a special-purpuse
  assignment so that it can be manipulated from a socket in LiveView, too
  """
  def set_title(conn, nil), do: conn
  def set_title(conn, title), do: conn |> assign(:page_title, title)

  @doc """
  Assigns the metadata for this page to the conn. You can use `title: "Title..."` for setting
  the page title, it is mapped to `set_title/2`. All other metadata is used to update the
  current :page assignment, which is a %Page{} struct by default.
  """
  def set_metadata(conn, page_data \\ []) do
    conn
    |> set_title(page_data[:title])
    |> assign(:page, conn.assigns.page |> struct(page_data))
  end
end
