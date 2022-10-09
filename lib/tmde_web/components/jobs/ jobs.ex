defmodule TmdeWeb.Components.Jobs do
  @moduledoc """
  Components to display job application details
  """
  use TmdeWeb, :component
  use TmdeWeb, :colocate_templates
  use Bulma
  alias TmdeWeb.Components.Jobs.{CV}
  alias Tmde.Contacts.Link, as: ContactLink
  alias Tmde.Jobs
  alias Tmde.Jobs.Skill

  import Jobs.PersonalSkill, only: [category_label: 1]
  import TmdeWeb.Components.ContentComponents

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

  def primary_skill(assigns) do
    ~H"""
      <div class="my-2">
        <strong><.label {assigns} /></strong>
        <progress class="progress is-info" value={@rating} max="100" title={@value}><%= @value %></progress>
      </div>
    """
  end

  def featured_skillset(assigns) do
    ~H"""
      <CV.panel title={category_label(@category)}>
        <%= for skill <- @skills do %>
          <.primary_skill skill={skill} />
        <% end %>

      </CV.panel>
    """
  end

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
        color: if(myskill.is_featured, do: "info")
      )
      |> assign(Skill.get_icon_details(skill))

    ~H"""
      <div class="tags has-addons">
        <Tags.tag class="skill" color={@color}>
          <.label {assigns} />
        </Tags.tag>
        <Tags.tag color="success"  label={translate(text)} />
      </div>
    """
  end

  def skill(assigns) do
    ~H"""
      <Tags.tag class="skill" color={assigns[:color]}>
        <.label {assigns} />
      </Tags.tag>
    """
  end

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

  def qr_code(%{qr_code: nil} = assigns) do
    ~H"""
    """
  end

  def qr_code(assigns) do
    render("qr_code.html", assigns)
  end

  def document_list(assigns) do
    IO.inspect(assigns)
    render("document_list.html", assigns)
  end
end
