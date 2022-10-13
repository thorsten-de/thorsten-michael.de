defmodule TmdeWeb.JobsLive do
  use TmdeWeb, :live_view
  use Bulma
  alias Tmde.Jobs
  alias TmdeWeb.Components.Jobs.CV
  import TmdeWeb.Components.Jobs
  import TmdeWeb.Components.ContactComponents
  import TmdeWeb.DocumentView, only: [document_filepath: 2]

  def mount(%{"token" => token}, _session, socket) do
    with {:ok, id} <- Jobs.Application.token_to_id(token),
         %Jobs.Application{} = application <- Jobs.get_application!(id) do
      unless connected?(socket),
        do:
          Jobs.log_event!(application, "APPLICATION_VISITED", %{
            locale: socket.assigns[:locale],
            token: token
          })

      socket =
        socket
        |> assign(application: application, get_url: get_url_builder(:jobs_path, token))

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
        |> assign(
          application: application,
          get_url: get_url_builder(:document_preview_path, application)
        )

      {:ok, socket}
    else
      err ->
        IO.inspect(err)
        {:ok, socket}
    end
  end

  defp get_url_builder(path, id),
    do: fn document ->
      apply(Routes, path, [TmdeWeb.Endpoint, :download_document, id, document.slug])
    end
end
