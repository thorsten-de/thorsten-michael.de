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

  def cv(%{application: application} = assigns) do
    entries =
      application.cv_entries
      |> Enum.group_by(& &1.type)

    assigns =
      assigns
      |> assign_defaults(socket: TmdeWeb.Endpoint, qr_code: nil)
      |> assign_class(["cv"])
      |> set_attributes_from_assigns([:socket, :application])
      |> assign(myself: application.job_seeker, entries: entries)

    render("cv.html", assigns)
  end

  def primary_skill(assigns) do
    ~H"""
      <div class="my-2">
        <strong><.label {assigns} /></strong>
        <progress class="progress is-info" value={@rating} max="100" title={@value}><%= @value %></progress>
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

  def skill_set(assigns) do
    ~H"""
      <Tags.tags class="skill-set">
        <%= for skill <- @skills do %>
          <.skill {skill} />
        <% end %>
      </Tags.tags>
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
