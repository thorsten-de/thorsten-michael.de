defmodule TmdeWeb.Components.Jobs.CV do
  @moduledoc """
  Components to display an applications CV
  """
  use TmdeWeb, :component
  use TmdeWeb, :colocate_templates
  import TmdeWeb.Components.Jobs, except: [template_not_found: 2, render: 2]
  alias TmdeWeb.Components.Jobs.CV
  alias Tmde.Contacts.Link, as: ContactLink

  use Bulma

  def entry(%{entry: entry} = assigns) do
    assigns =
      assigns
      |> assign(description: translate(entry.description))
      |> assign_class(["cv-entry", "pt-0", ["pt-0", "pb-3": !Enum.empty?(entry.focuses)]])

    render("cv_entry.html", assigns)
  end

  def entry_header(%{entry: entry} = assigns) do
    assigns =
      assigns
      |> assign(
        subtitle: "#{entry.company.name}, #{entry.company.location}",
        title: translate(entry.role),
        description: translate(entry.description)
      )

    render("cv_entry_header.html", assigns)
  end

  @featured_categories [:languages, :featured]
  def sidebar(assigns) do
    application = assigns.application

    {featured_skillsets, skillsets} =
      application.job_seeker.skills
      |> Enum.group_by(& &1.category)
      |> Enum.split_with(fn {category, _} -> category in @featured_categories end)

    assigns =
      assigns
      |> assign_defaults(socket: TmdeWeb.Endpoint)
      |> assign_class(["cv"])
      |> set_attributes_from_assigns(exclude: [:socket, :application])
      |> assign(
        myself: application.job_seeker,
        featured_skillsets: @featured_categories |> Enum.map(&{&1, featured_skillsets[&1]}),
        skillsets: skillsets
      )

    render("cv_sidebar.html", assigns)
  end

  def section(assigns) do
    render("cv_section.html", assigns)
  end

  def focus(%{focus: focus} = assigns) do
    assigns =
      assigns
      |> assign(abstract: translate(focus.abstract))

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
