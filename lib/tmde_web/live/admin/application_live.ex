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
  import Components.Jobs, only: [document_list: 1]

  def mount(_params, _session, socket) do
    application = Jobs.new_application(socket.assigns.current_user)

    socket =
      socket
      |> assign(
        application: application,
        changeset: Jobs.change_application(application),
        languages: Content.all_locales(),
        generate_documents?: false,
        send_email?: false
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

  def handle_event("update-application", %{"application" => params}, socket) do
    socket.assigns.application
    |> Jobs.insert_or_update_application(params)
    |> case do
      {:ok, application} ->
        EditorCard.close_editor("application-editor")

        {:noreply,
         socket
         |> assign(
           application: application,
           changeset: Jobs.change_application(application)
         )}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("generate-documents", _, socket) do
    send(self(), :generate_documents)
    {:noreply, assign(socket, generate_documents?: true)}
  end

  def handle_event("send-email", _, socket) do
    send(self(), :send_email)
    {:noreply, assign(socket, send_email?: true)}
  end

  def handle_info(:generate_documents, socket) do
    application = socket.assigns.application
    documents = TmdeWeb.DocumentView.generate_documents(application)

    socket =
      case Jobs.update_documents(application, documents) do
        {:ok, application} ->
          assign(socket, application: application, changeset: Jobs.change_application(application))

        {:error, changeset} ->
          assign(socket, changeset: changeset)
      end

    {:noreply, assign(socket, generate_documents?: false)}
  end

  def handle_info(:send_email, socket) do
    application = socket.assigns.application

    application
    |> TmdeWeb.ApplicationMailer.send_application()
    |> Tmde.Mailer.deliver()

    {:noreply, assign(socket, send_email?: false)}
  end
end
