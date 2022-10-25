defmodule TmdeWeb.Components.Forms do
  use TmdeWeb, :component
  use TmdeWeb, :colocate_templates
  use Bulma
  alias Tmde.Contacts.{Contact, Country}

  def address_form(assigns) do
    countries =
      Country.all()
      |> Enum.map(&{&1.iso, &1.title})

    render("address_form.html", form: assigns.form, countries: countries)
  end

  def contact_form(assigns) do
    render("contact_form.html", assigns)
  end

  @spec editor_card(map) :: Phoenix.LiveView.Rendered.t()
  @doc """
  Functional component that toggles card content if in edit mode. Events
  have to be handled in the corresponding LiveView or another class that
  is specified via the 'target' attribute.
  """
  attr :header, :string, doc: "Card-header for the editor"
  attr :edit?, :boolean, default: false, doc: "Is in edit mode?"
  attr :target, :any, required: true, doc: "phx-target that handles events for this modal"
  attr :class, :any

  slot :inner_block, doc: "Card content that is always visible"
  slot :presenter, doc: "Card content that is visible when not in edit mode"
  slot :editor, doc: "Card content that is visible in edit mode only"

  def editor_card(assigns) do
    assigns =
      assigns
      |> assign_class([])

    ~H"""
    <.card class={@class}>
      <:header label={@header}>
        <a href="#" class="card-header-icon" phx-click="toggle-editor" phx-target={@target}>
          <.label icon="edit" />
        </a>
      </:header>
      <:footer>
        <%= if @edit? do %>
          <a class="card-footer-item" phx-click="toggle-editor" phx-target={@target}><%= gettext("Cancel") %></a>
          <input class="card-footer-item" type="submit" value={gettext("Save")}>
        <% end %>
      </:footer>
      <%= render_slot(@inner_block) %>
      <%= if @edit? do %>
        <%= render_slot(@editor) %>
      <% else %>
        <%= render_slot(@presenter) %>
      <% end %>
    </.card>
    """
  end
end
