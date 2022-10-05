defmodule TmdeWeb.Components.Contact.ContactEditor do
  use TmdeWeb, :live_component
  use Bulma
  alias Tmde.Contacts
  import TmdeWeb.Components.ContactComponents
  import TmdeWeb.Components.Forms, only: [editor_card: 1, contact_form: 1]

  def mount(socket) do
    {:ok, assign(socket, edit?: false)}
  end

  def update(%{obj: obj, field: field} = assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign_contact()
      |> assign(changeset: Contacts.change_contact(obj, field))

    {:ok, socket}
  end

  def handle_event("toggle-editor", _params, socket), do: {:noreply, toggle(socket, :edit?)}

  def handle_event("save", %{"object" => params}, %{assigns: %{obj: obj, field: field}} = socket) do
    case Contacts.update_contact(obj, field, params) do
      {:ok, obj} ->
        {:noreply,
         socket
         |> assign(
           obj: obj,
           changeset: Contacts.change_contact(obj, field),
           edit?: false
         )
         |> assign_contact()}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def assign_contact(socket) do
    socket
    |> assign(contact: Map.get(socket.assigns.obj, socket.assigns.field))
  end
end
