defmodule TmdeWeb.Components.Navigation do
  use TmdeWeb, :component
  use TmdeWeb, :colocate_templates
  use Bulma

  alias Tmde.Blog
  alias Bulma.Footer
  alias Bulma.Navbar

  @doc """
  The footer for my website
  """
  attr :conn, :any, default: TmdeWeb.Endpoint

  def footer(assigns) do
    assigns =
      assigns
      |> assign(blog_posts: Blog.recent_posts(5, language: Gettext.get_locale(TmdeWeb.Gettext)))

    render("footer.html", assigns)
  end

  @doc """
  The navbar for my website
  """
  attr :current_user, :any, default: nil
  def navbar(assigns), do: render("navbar.html", assigns)
end
