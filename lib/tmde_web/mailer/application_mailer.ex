defmodule TmdeWeb.ApplicationMailer do
  use Phoenix.Swoosh, view: TmdeWeb.ApplicationMailerView
  alias Tmde.Contacts.Contact
  import TmdeWeb.Gettext

  def send_application(application) do
    attachments = prepare_attachments(application)

    new()
    |> from({Contact.name(application.sender), application.sender.email})
    |> to({Contact.name(application.contact), application.contact.email})
    |> subject(application.subject)
    |> render_body(:application,
      application: application,
      attachments: attachments,
      styling: %{bg_color: "#ffffff"}
    )
  end

  def prepare_attachments(application) do
    [
      %{
        name: gettext("application documents"),
        filename:
          gettext("%{sender} - application documents for %{reference}",
            sender: application.sender,
            reference: application.reference
          )
      }
    ]
  end
end