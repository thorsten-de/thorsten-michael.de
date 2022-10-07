defmodule TmdeWeb.Admin.ApplicationLive do
  use TmdeWeb, :live_view
  use Bulma
  alias Tmde.Jobs
  alias TmdeWeb.Components
  alias Components.Content.TranslationEditor

  def handle_params(%{"id" => id}, _, socket) do
    application = Jobs.get_application!(id)

    socket =
      socket
      |> assign(application: application)

    {:noreply, socket}
  end
end
