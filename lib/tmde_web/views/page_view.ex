defmodule TmdeWeb.PageView do
  use TmdeWeb, :view
  use Bulma
  import TmdeWeb.Components.List, only: [property_list: 1]

  def render_dl(list) do
    content_tag(:dl, class: "property-list") do
      for {key, value} <- list do
        [
          content_tag(:dt, key),
          content_tag(:dd, value)
        ]
      end
    end
  end
end
