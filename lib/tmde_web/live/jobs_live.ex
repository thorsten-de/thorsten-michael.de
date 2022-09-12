defmodule TmdeWeb.JobsLive do
  use TmdeWeb, :live_view
  use Bulma
  alias Tmde.Jobs
  alias Tmde.Contacts.Link
  import TmdeWeb.Components.Jobs

  def mount(%{"id" => application_id}, _session, socket) do
    application = Jobs.get_application!(application_id)

    entries =
      application.cv_entries
      |> Enum.group_by(& &1.type)

    socket =
      socket
      |> assign(
        application: application,
        entries: entries,
        myself: application.job_seeker,
        is_cv?: application_id == "cv"
      )

    {:ok, socket}
  end
end
