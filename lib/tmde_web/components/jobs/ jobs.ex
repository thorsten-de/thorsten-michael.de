defmodule TmdeWeb.Components.Jobs do
  @moduledoc """
  Components to display job application details
  """
  use TmdeWeb, :component
  use TmdeWeb, :colocate_templates
  use Bulma
  import Bulma.Helpers, only: [assign_class: 2, has: 1, is: 1]

  def cv_article(%{entry: entry} = assigns) do
    assigns =
      assigns
      |> assign(
        subtitle: "#{entry.company.name}, #{entry.company.location}",
        title: translate(entry.role),
        description: translate_html(entry.description)
      )

    render("cv_article.html", assigns)
  end

  def cv_section(assigns) do
    render("cv_section.html", assigns)
  end

  def cv_focus(%{focus: focus} = assigns) do
    assigns =
      assigns
      |> assign(abstract: translate_html(focus.abstract))

    render("cv_focus.html", assigns)
  end

  def cv_panel(assigns) do
    assigns =
      assigns
      |> assign_defaults(title: nil, inner_block: [])
      |> assign_class(["my-6", "mx-4", has(:text)])

    ~H"""
      <div class={@class}>
        <%= if @title do %>
          <.title class="mb-3" size="5" label={@title} />
        <% end %>
        <%= render_slot(@inner_block) %>
      </div>
    """
  end

  def primary_skill(assigns) do
    ~H"""
      <div class="my-2">
        <strong><.label {assigns} /></strong>
        <progress class="progress is-info" value={@rating} max="100"><%= @value %></progress>
      </div>
    """
  end

  @spec skill(any) :: Phoenix.LiveView.Rendered.t()
  def skill(assigns) do
    assigns =
      assigns
      |> assign_class(["tag", "skill", "is-normal", is(:color)])
      |> set_attributes_from_assigns([:color])

    ~H"""
      <span class={@class}>
        <.label {@attributes} />
      </span>
    """
  end

  def translate_html(content), do: content |> translate() |> raw()
end
