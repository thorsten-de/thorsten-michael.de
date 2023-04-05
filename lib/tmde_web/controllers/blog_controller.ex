defmodule TmdeWeb.BlogController do
  @moduledoc """
  Controller for blog articles
  """
  use TmdeWeb, :controller

  alias Tmde.Blog

  def show(conn, %{"id" => id}) do
    locale = Gettext.get_locale(TmdeWeb.Gettext)
    post = Blog.get_post_by_id!(id)

    if post.language != locale && post.links[locale] do
      conn
      |> redirect(to: Routes.blog_path(conn, :show, post.links[locale]))
    end



    conn
     |> set_metadata(
      title: post.title,
      description: post.abstract
    )
    |> render("show.html", post: Blog.get_post_by_id!(id), )
  end
end
