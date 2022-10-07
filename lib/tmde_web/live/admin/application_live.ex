defmodule TmdeWeb.Admin.ApplicationLive do
  use TmdeWeb, :live_view
  use Bulma
  alias Tmde.Jobs
  alias TmdeWeb.Components
  alias Components.Content.TranslationEditor

  def mount(_params, _session, socket) do
    application = %Jobs.Application{subject: "New Application", reference: "Reference"}

    socket =
      socket
      |> assign(application: application)

    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _, socket) do
    application = Jobs.get_application!(id)

    socket =
      socket
      |> assign(application: application)

    {:noreply, socket}
  end

  def handle_params(_, _, socket), do: {:noreply, socket}
end
