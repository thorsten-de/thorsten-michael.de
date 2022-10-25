defmodule TmdeWeb.Components.Jobs do
  @moduledoc """
  Components to display job application details
  """
  use TmdeWeb, :component
  use TmdeWeb, :colocate_templates
  use Bulma
  alias TmdeWeb.Components.Jobs.{CV}
  alias Tmde.Jobs
  alias Tmde.Jobs.Skill

  import Jobs.PersonalSkill, only: [category_label: 1]

  @spec cv(map) :: Phoenix.LiveView.Rendered.t()
  @doc """
  Display the CV section of an application
  """
  attr :application, Jobs.Application, required: true
  def cv(%{application: application} = assigns) do
    entries =
      application.job_seeker.cv_entries
      |> Enum.group_by(& &1.type)

    assigns =
      assigns
      |> assign_defaults(socket: TmdeWeb.Endpoint)
      |> set_attributes_from_assigns(exclude: [:socket, :application])
      |> assign(entries: entries)

    render("cv.html", assigns)
  end

  @spec primary_skill(any) :: Phoenix.LiveView.Rendered.t()
  @doc """
  Show a primary skill, usually with some visual rating like a progress bar.
  Used for showing my language and featured skills.
  """
  attr :skill, Jobs.PersonalSkill, required: true
  def primary_skill(%{skill: %{skill: skill} = myskill} = assigns) do
    assigns =
      assigns
      |> assign(
        label: translate(skill.label),
        rating: myskill.rating,
        value: translate(myskill.rating_text)
      )
      |> assign(Skill.get_icon_details(skill))

    ~H"""
      <div class="my-2">
        <strong><.label {assigns} /></strong>
        <progress class="progress is-info" value={@rating} max="100" title={@value}><%= @value %></progress>
      </div>
    """
  end


  @spec featured_skillset(any) :: Phoenix.LiveView.Rendered.t()
  @doc """
  Show a panel with featured skills, using primary_skill components
  """
  attr :category, :atom, required: true
  attr :skills, :list, required: true
  def featured_skillset(assigns) do
    ~H"""
      <CV.panel title={category_label(@category)}>
        <%= for skill <- @skills do %>
          <.primary_skill skill={skill} />
        <% end %>

      </CV.panel>
    """
  end

  @spec skill(any) :: Phoenix.LiveView.Rendered.t()
  @doc """
  Show a skill, here using a bulma tag component
  """
  attr :skill, Jobs.PersonalSkill, required: true
  attr :color, :any, doc: "Bulma tag color"
  def skill(%{skill: %{skill: skill, rating_text: []} = myskill} = assigns) do
    assigns =
      assigns
      |> assign(
        label: translate(skill.label),
        color: if(myskill.is_featured, do: "info")
      )
      |> assign(Skill.get_icon_details(skill))

    ~H"""
      <Tags.tag class="skill" color={@color}>
        <.label {assigns} />
      </Tags.tag>
    """
  end

  def skill(%{skill: %{skill: skill, rating_text: text} = myskill} = assigns)
      when is_list(text) do
    assigns =
      assigns
      |> assign(
        label: translate(skill.label),
        text: text,
        color: if(myskill.is_featured, do: "info")
      )
      |> assign(Skill.get_icon_details(skill))

    ~H"""
      <div class="tags has-addons">
        <Tags.tag class="skill" color={@color}>
          <.label {assigns} />
        </Tags.tag>
        <Tags.tag color="success"  label={translate(@text)} />
      </div>
    """
  end

  @spec skillset(any) :: Phoenix.LiveView.Rendered.t()
  @doc """
  A Panel with a set of skills, displayed with the skill component
  """
  attr :category, :atom, required: true
  attr :skills, :list, required: true
  def skillset(assigns) do
    ~H"""
    <CV.panel title={category_label(@category)}>
      <Tags.tags class="skill-set">
        <%= for skill <- @skills do %>
          <.skill skill={skill} />
        <% end %>
      </Tags.tags>
    </CV.panel>
    """
  end

  @spec qr_code(any) :: any
  @doc """
  Renders QR-code data to the document/page
  """
  attr :qr_code, :any
  def qr_code(%{qr_code: nil} = assigns) do
    ~H"""
    """
  end

  def qr_code(assigns) do
    render("qr_code.html", assigns)
  end

  @spec document_list(any) :: Phoenix.LiveView.Rendered.t()
  @doc """
  Display a list (ul here) of documents, with links to the downloads
  """
  attr :documents, :list, required: true
  attr :url_for, :any, required: true, doc: "a function that turns a document into its url"
  def document_list(assigns) do
    render("document_list.html", assigns)
  end
end
