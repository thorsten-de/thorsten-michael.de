defmodule TmdeWeb.Components.Content.TranslationEditor do
  use TmdeWeb, :live_component
  use Bulma
  import TmdeWeb.Components.List, only: [property_list: 1]

  alias Tmde.Content
  alias Tmde.Content.Translation

  def mount(socket) do
    {:ok, assign(socket, edit?: false)}
  end

  def update(%{obj: obj, field: field} = assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign_translations()
      |> assign(
        changeset: Content.change_translations(obj, field),
        types: Translation.all_content_types(),
        languages: Content.all_locales()
      )

    {:ok, socket}
  end

  def handle_event("toggle-editor", _params, socket),
    do: {:noreply, toggle(socket, :edit?)}

  def handle_event("cancel", _params, socket) do
    socket =
      socket
      |> assign(edit?: false)

    {:noreply, socket}
  end

  def handle_event("preview", %{"object" => params}, socket) do
    previews =
      params[socket.assigns.field |> to_string()]
      |> Enum.map(fn {_, t} ->
        Translation.changeset(%Translation{id: t["id"]}, t)
        |> Ecto.Changeset.apply_action!(:update)
      end)
      |> Enum.reduce(socket.assigns.previews, fn t, acc ->
        Map.put(acc, t.id, t)
      end)

    {:noreply, assign(socket, previews: previews)}
  end

  def handle_event("save", %{"object" => params}, %{assigns: %{obj: obj, field: field}} = socket) do

    case Content.update_translations(obj, field, params)
      {:ok, obj} ->
        {:noreply,
         socket
         |> assign(
           obj: obj,
           changeset: Content.change_translations(obj, field),
           edit?: false
         )
         |> assign_translations()}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("add-translation", _, %{assigns: %{obj: obj, field: field}} = socket) do
    case Content.add_translation(obj, field, %{content: "Text"}) do
      {:ok, obj} ->
        {:noreply,
         socket
         |> assign(
           obj: obj,
           changeset: Content.change_translations(obj, field),
           edit?: true
         )}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp assign_translations(socket) do
    %{obj: obj, field: field} = socket.assigns

    socket
    |> assign(translations: Map.get(obj, field))
  end
end
