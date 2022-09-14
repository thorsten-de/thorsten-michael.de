defmodule TmdeWeb.Components.Jobs do
  @moduledoc """
  Components to display job application details
  """
  use TmdeWeb, :component
  use TmdeWeb, :colocate_templates
  use Bulma
  import Bulma.Helpers, only: [assign_class: 2, is: 1]
  alias TmdeWeb.Components.Jobs.{CV}
  alias Tmde.Contacts.Link, as: ContactLink
  alias Tmde.Jobs.Skill

  def cv(%{application: application} = assigns) do
    entries =
      application.cv_entries
      |> Enum.group_by(& &1.type)

    {featured_skillsets, skillsets} =
      application.job_seeker.skills
      |> Enum.group_by(& &1.category)
      |> Enum.split_with(fn {category, _} -> category in [:languages, :featured] end)
      |> IO.inspect()

    assigns =
      assigns
      |> assign_defaults(socket: TmdeWeb.Endpoint, qr_code: nil)
      |> assign_class(["cv"])
      |> set_attributes_from_assigns([:socket, :application])
      |> assign(
        myself: application.job_seeker,
        entries: entries,
        featured_skillsets: featured_skillsets,
        skillsets: skillsets
      )

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
      <CV.panel title={@category}>
        <%= for skill <- @skills do %>
          <.primary_skill skill={skill} />
        <% end %>

      </CV.panel>
    """
  end

  def skill(%{skill: %{skill: skill} = myskill} = assigns) do
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

  def skill(assigns) do
    ~H"""
      <Tags.tag class="skill" color={assigns[:color]}>
        <.label {assigns} />
      </Tags.tag>
    """
  end

  def skillset(assigns) do
    ~H"""
    <CV.panel title={@category}>
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
end
