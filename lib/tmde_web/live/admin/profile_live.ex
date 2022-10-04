defmodule TmdeWeb.Admin.ProfileLive do
  use TmdeWeb, :live_view
  use Bulma
  alias Tmde.Jobs
  alias Tmde.Contacts.Link, as: ContactLink
  alias TmdeWeb.Components
  import Components.Forms.JobSeeker
  import Components.ContactComponents

  on_mount TmdeWeb.UserLiveAuth

  def mount(_params, _session, socket) do
    job_seeker = socket.assigns.current_user
    changeset = Jobs.change_job_seeker(job_seeker)

    applications = Jobs.job_seeker_applications(job_seeker)

    socket =
      assign(socket,
        changeset: changeset,
        job_seeker: job_seeker,
        applications: applications
      )

    {:ok, socket}
  end

  def handle_event("validate", %{"job_seeker" => params}, socket) do
    changeset =
      socket.assigns.current_user
      |> Jobs.change_job_seeker(params)
      |> Map.put(:action, :update)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("update_user", %{"job_seeker" => params}, socket) do
    socket.assigns.current_user
    |> Jobs.update_job_seeker(params)
    |> case do
      {:ok, job_seeker} ->
        {:noreply,
         socket
         |> put_flash(:info, "Daten geändert")
         |> assign(changeset: Jobs.change_job_seeker(job_seeker), current_user: job_seeker)}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
