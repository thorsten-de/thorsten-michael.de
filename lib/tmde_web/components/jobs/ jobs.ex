defmodule TmdeWeb.Components.Jobs do
  @moduledoc """
  Components to display job application details
  """
  use TmdeWeb, :component
  use TmdeWeb, :colocate_templates
  use Bulma

  def cv_article(assigns) do
    render("cv_article.html", assigns)
  end
end
