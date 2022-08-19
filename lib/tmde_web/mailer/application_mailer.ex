defmodule TmdeWeb.ApplicationMailer do
  use Phoenix.Swoosh, view: TmdeWeb.ApplicationMailerView

  def send_application(application) do
    new()
    |> from({application.sender.name, application.sender.email})
    |> to({application.contact.name, application.recipient})
    |> subject(application.subject)
    |> render_body(:application, application: application, styling: %{bg_color: "#ffffff"})
  end
end
