defmodule TmdeWeb.BlogController do
  @moduledoc """
  Controller for blog articles
  """
  use TmdeWeb, :controller

  alias Tmde.Blog

  def show(conn, %{"id" => id}) do
    conn
    |> render("show.html", post: Blog.get_post_by_id!(id))
  end
end
