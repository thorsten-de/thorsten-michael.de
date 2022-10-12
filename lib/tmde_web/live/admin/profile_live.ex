defmodule TmdeWeb.Admin.ProfileLive do
  use TmdeWeb, :live_view
  use Bulma
  alias Tmde.Jobs
  alias Jobs.CV
  alias TmdeWeb.Components
  alias Components.Content.TranslationEditor
  alias Components.Contact.ContactEditor
  alias Components.Jobs.CV.EntryEditor

  import TmdeWeb.Admin.Profile.Editors,
    only: [personal_data_editor: 1, links_editor: 1]

  alias Components.Forms.EditorCard

  on_mount TmdeWeb.UserLiveAuth

  def mount(_params, _session, socket) do
    job_seeker = socket.assigns.current_user
    changeset = Jobs.change_job_seeker(job_seeker)

    applications = Jobs.job_seeker_applications(job_seeker)

    socket =
      assign(socket,
        changeset: changeset,
        applications: applications
      )
      |> assign_cv()

    {:ok, socket}
  end

  def handle_event("validate", %{"job_seeker" => params}, socket) do
    changeset =
      socket.assigns.current_user
      |> Jobs.change_job_seeker(params)
      |> Map.put(:action, :update)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("update_personal_data", %{"job_seeker" => params}, socket) do
    socket
    |> do_user_update(params, editor_id: "personal_data_editor")
  end

  def handle_event("update_links", %{"job_seeker" => params}, socket) do
    socket
    |> do_user_update(params, editor_id: "links_editor")
  end

  defp do_user_update(socket, params, opts) do
    socket.assigns.current_user
    |> Jobs.update_job_seeker(params)
    |> case do
      {:ok, job_seeker} ->
        EditorCard.close_editor(opts[:editor_id])

        {:noreply,
         socket
         |> assign(changeset: Jobs.change_job_seeker(job_seeker), current_user: job_seeker)}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def assign_cv(socket) do
    socket
    |> assign(cv: Jobs.get_cv(socket.assigns.current_user))
  end
end
