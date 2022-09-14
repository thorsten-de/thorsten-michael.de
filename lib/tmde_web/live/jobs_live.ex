defmodule TmdeWeb.JobsLive do
  use TmdeWeb, :live_view
  use Bulma
  alias Tmde.Jobs
  import TmdeWeb.Components.Jobs

  def mount(%{"id" => application_id}, _session, socket) do
    application = Jobs.get_application!(application_id)

    socket =
      socket
      |> assign(
        application: application,
        print_layout?: application_id == "cv"
      )
      |> assign_qr_code()

    {:ok, socket}
  end

  # Generate QR-Code and assign it to the socket. Only needed in print layout
  @settings %QRCode.SvgSettings{qrcode_color: {54, 54, 54}}

  defp assign_qr_code(%{assigns: %{application: application, print_layout?: true}} = socket) do
    with {:ok, code} <-
           socket
           |> Routes.jobs_url(:show, application)
           |> QRCode.create(:low),
         svg_data <- QRCode.Svg.to_base64(code, @settings) do
      assign(socket, :qr_code, svg_data)
    else
      _errors ->
        socket
    end
  end

  defp assign_qr_code(socket), do: socket
end
