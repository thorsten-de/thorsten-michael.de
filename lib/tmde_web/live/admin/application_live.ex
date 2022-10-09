defmodule TmdeWeb.Admin.ApplicationLive do
  use TmdeWeb, :live_view
  use Bulma
  alias Tmde.Jobs
  alias Tmde.Content
  alias TmdeWeb.Components
  alias Components.Content.TranslationEditor
  alias Components.Contact.ContactEditor
  alias Components.Forms.EditorCard
  import Components.List

  def mount(_params, _session, socket) do
    application = %Jobs.Application{subject: "New Application", reference: "Reference"}

    socket =
      socket
      |> assign(
        application: application,
        changeset: Jobs.change_application(application),
        languages: Content.all_locales()
      )

    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _, socket) do
    application = Jobs.get_application!(id)

    socket =
      socket
      |> assign(
        application: application,
        changeset: Jobs.change_application(application)
      )

    {:noreply, socket}
  end

  def handle_params(_, _, socket), do: {:noreply, socket}
end
