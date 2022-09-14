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

  def qr_code(%{qr_code: nil} = assigns) do
    ~H"""
    """
  end

  def qr_code(assigns) do
    render("qr_code.html", assigns)
  end
end
