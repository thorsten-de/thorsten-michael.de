defmodule TmdeWeb.Components.Jobs.CV.EntryEditor do
  use TmdeWeb, :live_component
  use Bulma
  import TmdeWeb.Components.Forms, only: [editor_card: 1]
  import TmdeWeb.Components.Jobs.CV, only: [entry: 1]

  alias Tmde.Jobs

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
      <.editor_card target={@myself} edit?={@edit?}>
        <.entry entry={@entry} />
      </.editor_card>
    </div>
    """
  end

  defp assign_changeset(socket) do
    assign(socket, :changeset, Jobs.change_cv_entry(socket.assigns.entry))
  end

  def handle_event("toggle-editor", _params, socket), do: {:noreply, toggle(socket, :edit?)}
end
