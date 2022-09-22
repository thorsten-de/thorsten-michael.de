defmodule TmdeWeb.JobsLive do
  use TmdeWeb, :live_view
  use Bulma
  alias Tmde.Jobs
  import TmdeWeb.Components.Jobs

  def mount(%{"id" => application_id}, session, socket) do
    application = Jobs.get_application!(application_id)

    if locale = session["locale"], do: Gettext.put_locale(TmdeWeb.Gettext, locale)

    socket =
      socket
      |> assign(
        application: application,
        print_layout?: application_id == "cv"
      )

    {:ok, socket}
  end
end
