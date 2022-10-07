defmodule TmdeWeb.Components.Forms.EditorCard do
  use TmdeWeb, :live_component
  use Bulma
  import TmdeWeb.Components.Forms

  def mount(socket) do
    {:ok, assign(socket, edit?: false)}
  end

  def handle_event("toggle-editor", _params, socket) do
    {:noreply, toggle(socket, :edit?)}
  end

  def close_editor(id) do
    send_update(__MODULE__, id: id, edit?: false)
  end
end
