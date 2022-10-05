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

  def editor_card(assigns) do
    assigns =
      assigns
      |> assign_defaults(inner_block: [], editor: [], header: nil, edit?: false, target: nil)
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
      <%= if @edit? do %>
        <%= render_slot(@editor) %>
      <% else %>
        <%= render_slot(@inner_block) %>
      <% end %>
    </.card>
    """
  end
end
