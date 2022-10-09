defmodule TmdeWeb.JobsLive do
  use TmdeWeb, :live_view
  use Bulma
  alias Tmde.Jobs
  alias TmdeWeb.Components.Jobs.CV
  import TmdeWeb.Components.Jobs
  import TmdeWeb.ComponentHelpers
  import TmdeWeb.Components.{ContactComponents, ContentComponents}
  import TmdeWeb.DocumentView, only: [document_filepath: 2]

  def mount(%{"token" => token}, session, socket) do
    with {:ok, id} <- Jobs.Application.token_to_id(token),
         %Jobs.Application{} = application <- Jobs.get_application!(id) do
      unless connected?(socket),
        do:
          Jobs.log_event!(application, "APPLICATION_VISITED", %{
            locale: socket.assigns.locale,
            token: token
          })

      socket =
        socket
        |> assign(application: application)

      {:ok, socket}
    else
      err ->
        IO.inspect(err)
        {:ok, socket}
    end
  end

  def mount(%{"id" => id}, _session, socket) do
    with %Jobs.Application{} = application <- Jobs.get_application!(id) do
      socket =
        socket
        |> assign(application: application)

      {:ok, socket}
    else
      err ->
        IO.inspect(err)
        {:ok, socket}
    end
  end
end
