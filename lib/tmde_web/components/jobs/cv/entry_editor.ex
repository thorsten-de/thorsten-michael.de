defmodule TmdeWeb.Components.Jobs.CV.EntryEditor do
  use TmdeWeb, :live_component
  use Bulma
  import TmdeWeb.Components.Forms, only: [editor_card: 1]
  import TmdeWeb.Components.Jobs.CV, only: [entry: 1]
  alias TmdeWeb.Components.Content.TranslationEditor

  alias Tmde.Jobs
  alias Jobs.CV.Entry

  def mount(socket) do
    {:ok, assign(socket, edit?: false)}
  end

  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign_changeset()

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="entry-editor">
      <.entry entry={@entry} />
      <.button icon="plus" label={gettext("Focus")} click="add-focus" target={@myself}/>
      <.form let={f} for={@changeset} phx-submit="update-entry" phx-target={@myself}>
        <.editor_card target={@myself} edit?={@edit?} header={"#{gettext("Master Data")}: #{@entry.company.name}"}>
          <:editor>
            <.field form={f} name={:type} label={gettext("Section")} input={:select} options={Entry.cv_sections} />
            <.field form={f} name={:from} label={gettext("From")} input={:date_input} />
            <.field form={f} name={:until} label={gettext("Until")} input={:date_input} />
            <.field form={f} name={:icon} label={gettext("Icon")} input={:text_input} />
            <.inputs let={company} form={f} field={:company}>
              <.field form={company} name={:name} label={gettext("Company")} input={:text_input} />
              <.field form={company} name={:location} label={gettext("Location")} input={:text_input} />
            </.inputs>
          </:editor>
        </.editor_card>
      </.form>
      <.live_component module={TranslationEditor} obj={@entry} field={:description} header={gettext("Description")} id={"description-editor-#{@entry.id}"} />
      <.live_component module={TranslationEditor} obj={@entry} field={:role} header={gettext("Role")} id={"role-editor-#{@entry.id}"} />
      <%= for focus <- @entry.focuses do %>
        <.live_component module={TranslationEditor} obj={focus} field={:abstract} header={"#{gettext("Focus")} #{focus.sort_order}"} id={"focus-editor-#{focus.id}"} />
      <% end %>
    </div>
    """
  end

  defp assign_changeset(socket) do
    assign(socket, :changeset, Jobs.change_cv_entry(socket.assigns.entry))
  end

  def handle_event("toggle-editor", _params, socket), do: {:noreply, toggle(socket, :edit?)}

  def handle_event("add-focus", _params, socket) do
    case Jobs.add_focus_to_entry(socket.assigns.entry) do
      {:ok, entry} ->
        {:noreply,
         socket
         |> assign(entry: entry)
         |> assign_changeset()}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}

      end
  end

  def handle_event("update-entry", %{"entry" => params}, socket) do
    case Jobs.update_cv_entry(socket.assigns.entry, params) do
      {:ok, entry} ->
        {:noreply,
         socket
         |> assign(entry: entry)
         |> assign_changeset()}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

end
