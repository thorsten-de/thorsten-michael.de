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
      |> assign_qr_code()

    {:ok, socket}
  end

  @settings %QRCode.SvgSettings{qrcode_color: {54, 54, 54}}

  defp assign_qr_code(%{assigns: %{application: application, is_cv?: true}} = socket) do
    with {:ok, code} <-
           socket
           |> Routes.jobs_url(:show, application)
           |> QRCode.create(:low),
         svg_data <- QRCode.Svg.to_base64(code, @settings) do
      assign(socket, :qr_code, svg_data)
    else
      errs ->
        socket
    end
  end

  defp assign_qr_code(socket), do: socket
end
