defmodule TmdeWeb.Components.Navigation do
  use TmdeWeb, :component
  use TmdeWeb, :colocate_templates
  use Bulma

  alias Bulma.Footer
  alias Bulma.Navbar

  def footer(assigns), do: render("footer.html", assigns)

  def navbar(assigns), do: render("navbar.html", assigns)
end
