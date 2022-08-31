defmodule TmdeWeb.ApplicationMailer do
  use Phoenix.Swoosh, view: TmdeWeb.ApplicationMailerView
  alias Tmde.Contacts.Contact

  def send_application(application) do
    new()
    |> from({Contact.name(application.sender), application.sender.email})
    |> to({Contact.name(application.contact), application.contact.email})
    |> subject(application.subject)
    |> render_body(:application, application: application, styling: %{bg_color: "#ffffff"})
  end
end
