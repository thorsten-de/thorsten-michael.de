defmodule TmdeWeb.JobsLive do
  use TmdeWeb, :live_view
  use Bulma
  alias Tmde.Jobs
  import TmdeWeb.Components.Jobs

  def mount(%{"token" => token}, session, socket) do
    with {:ok, id} <- Jobs.Application.token_to_id(token),
         %Jobs.Application{} = application <- Jobs.get_application!(id) do
      unless connected?(socket),
        do: Jobs.log_event!(application, "APPLICATION_VISITED")

      if locale = session["locale"], do: Gettext.put_locale(TmdeWeb.Gettext, locale)

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
