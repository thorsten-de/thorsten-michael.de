defmodule TmdeWeb.Components.Jobs.CV do
  @moduledoc """
  Components to display an applications CV
  """
  use TmdeWeb, :component
  use TmdeWeb, :colocate_templates
  import TmdeWeb.Components.Jobs, except: [template_not_found: 2, render: 2]
  alias TmdeWeb.Components.Jobs.CV
  alias Tmde.Contacts.Link, as: ContactLink
  alias Tmde.Jobs

  use Bulma

  @spec entry(map) :: any
  @doc """
  Show a main CV entry (that is, a job experience, project or education)
  """
  attr :entry, Jobs.CV.Entry, required: true
  def entry(%{entry: entry} = assigns) do
    assigns =
      assigns
      |> assign(description: translate(entry.description))
      |> assign_class(["cv-entry", "pt-0", ["pt-0", "pb-3": !Enum.empty?(entry.focuses)]])

    render("cv_entry.html", assigns)
  end

  @doc """
  The cv entry header, build from an entry
  """
  attr :entry, Jobs.CV.Entry, required: true
  def entry_header(%{entry: entry} = assigns) do
    assigns =
      assigns
      |> assign(
        subtitle: "#{entry.company.name}, #{entry.company.location}",
        title: translate(entry.role)
      )

    render("cv_entry_header.html", assigns)
  end

  @featured_categories [:languages, :featured]

  @spec sidebar(map) :: any
  @doc """
  The job_seeker sidebar content
  """
  attr :application, Jobs.Application, required: true
  attr :class, :any

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

  @spec section(any) :: any
  @doc """
  A section of the CV, usually titled with a category label
  """
  attr :title, :string, required: true, doc: "section title used as header"
  attr :entries, :list, required: true
  def section(assigns) do
    render("cv_section.html", assigns)
  end

  @spec focus(map) :: any
  @doc """
  Show a focus item of a CV entry
  """
  attr :focus, Jobs.CV.Focus, required: true
  def focus(%{focus: focus} = assigns) do
    assigns =
      assigns
      |> assign(abstract: translate(focus.abstract))

    render("cv_focus.html", assigns)
  end

  @spec panel(any) :: Phoenix.LiveView.Rendered.t()
  @doc """
  A panel to give space between contents. Can have a title header
  """
  attr :title, :string, doc: "title header for the panel"
  slot :inner_block, required: true
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
