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

  def handle_event("save", %{"object" => params}, %{assigns: %{obj: obj, field: field}} = socket),
    do:
      obj
      |> Content.update_translations(field, params)
      |> success_or_error(socket, edit?: false)

  def handle_event(
        "add-translation",
        %{"lang" => lang},
        %{assigns: %{obj: obj, field: field}} = socket
      ) do
    new_content =
      with [%Translation{lang: source_lang, content: text, type: type} | _] <-
             socket.assigns.translations,
           [translation] <-
             DeeplEx.translate(
               target_lang: lang,
               text: text,
               source_lang: source_lang,
               split_sentences: "nonewlines",
               formality: "prefer_more"
             ) do
        %{type: type, content: translation.text, lang: lang}
      else
        _ -> %{text: "Text", lang: lang}
      end

    obj
    |> Content.add_translation(field, new_content)
    |> success_or_error(socket, edit?: true)
  end

  def handle_event(
        "remove-translation",
        %{"id" => id},
        %{assigns: %{obj: obj, field: field}} = socket
      ),
      do:
        obj
        |> Content.remove_translation(field, id)
        |> success_or_error(socket)

  def success_or_error(result, socket, additional_assignments \\ [])

  def success_or_error({:ok, obj}, socket, additional_assignments),
    do:
      {:noreply,
       socket
       |> assign(
         obj: obj,
         changeset: Content.change_translations(obj, socket.assigns.field)
       )
       |> assign(additional_assignments)
       |> assign_translations()}

  def success_or_error({:error, changeset}, socket, _additional_assignments),
    do: {:noreply, assign(socket, changeset: changeset)}

  defp assign_translations(socket) do
    %{obj: obj, field: field} = socket.assigns

    socket
    |> assign(translations: Map.get(obj, field))
  end
end
