defmodule TmdeWeb.Components.Navigation do
  use TmdeWeb, :component
  use TmdeWeb, :colocate_templates

  alias Bulma.Footer

  def footer(assigns), do: render("footer.html", assigns)
end
