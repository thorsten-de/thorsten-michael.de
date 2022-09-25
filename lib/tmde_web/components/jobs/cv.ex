defmodule TmdeWeb.Components.Jobs.CV do
  @moduledoc """
  Components to display an applications CV
  """
  use TmdeWeb, :component
  use TmdeWeb, :colocate_templates

  use Bulma

  def entry(%{entry: entry} = assigns) do
    assigns =
      assigns
      |> assign(
        subtitle: "#{entry.company.name}, #{entry.company.location}",
        title: translate(entry.role),
        description: translate_html(entry.description)
      )
      |> assign_class(["cv-entry", "pt-0", ["pt-0", "pb-3": !Enum.empty?(entry.focuses)]])

    render("cv_entry.html", assigns)
  end

  def section(assigns) do
    render("cv_section.html", assigns)
  end

  def focus(%{focus: focus} = assigns) do
    assigns =
      assigns
      |> assign(abstract: translate_html(focus.abstract))

    render("cv_focus.html", assigns)
  end

  def panel(assigns) do
    assigns =
      assigns
      |> assign_defaults(title: nil, inner_block: [])
      |> assign_class(["my-5", "mr-4", has(:text)])

    ~H"""
      <div class={@class}>
        <%= if @title do %>
          <.title class="mb-3" size="5" label={@title} />
        <% end %>
        <%= render_slot(@inner_block) %>
      </div>
    """
  end
end
