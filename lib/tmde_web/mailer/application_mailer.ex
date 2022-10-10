defmodule TmdeWeb.ApplicationMailer do
  use Phoenix.Swoosh, view: TmdeWeb.ApplicationMailerView, layout: {TmdeWeb.LayoutView, :email}
  alias Tmde.Contacts.Contact
  import TmdeWeb.Gettext
  alias TmdeWeb.Router.Helpers, as: Routes
  alias Tmde.Jobs
  alias Tmde.Jobs.Delivery
  import TmdeWeb.ComponentHelpers, only: [translate: 1]

  def set_sender(email, %{contact: contact, links: _links} = sender) do
    email
    |> from({Contact.name(contact), contact.email})
    |> bcc(contact.email)
    |> assign(:sender, sender)
  end

  def create_delivery(email, opts) do
    {:ok, delivery} =
      Jobs.create_delivery(opts[:application], %{subject: email.subject, email: opts[:email]})

    email
    |> assign(:delivery_token, delivery |> Delivery.sign_token())
  end

  @spec set_mail_defaults(Swoosh.Email.t()) :: Swoosh.Email.t()
  def set_mail_defaults(email) do
    email
    |> assign(:styling, %{bg_color: "#ffffff"})
    |> assign(:logo_target, Routes.page_url(TmdeWeb.Endpoint, :index))
    |> assign(:locale, "de")
    |> assign(:title, email.subject)
  end

  def send_mail(%{sender: sender, recipient: recipient, subject: subject, body: body}) do
    new()
    |> to({Contact.name(recipient), recipient.email})
    |> subject(subject)
    |> set_mail_defaults()
    |> set_sender(sender)
    |> create_delivery(email: recipient.email)
    |> render_body("mail.html", body: body)
  end

  def send_application(application) do
    token = Tmde.Jobs.Application.sign_token(application)

    Gettext.with_locale(TmdeWeb.Gettext, application.locale, fn ->
      new()
      |> to({Contact.name(application.contact), application.contact.email})
      |> subject(application.subject |> translate |> to_string())
      |> set_mail_defaults()
      |> set_sender(application.job_seeker)
      |> assign(:locale, application.locale)
      |> create_delivery(email: application.contact.email, application: application)
      |> prepare_attachments(application)
      |> render_body(:application,
        logo_target: Routes.jobs_url(TmdeWeb.Endpoint, :show, token),
        application: application
      )
    end)
  end

  def prepare_attachments(email, application) do
    [attachment | _] = application.documents

    email
    |> assign(:attachments, [attachment])
    |> attachment(
      Swoosh.Attachment.new(attachment.filename,
        filename:
          gettext("%{sender} - application documents for %{reference}",
            sender: email.assigns.sender.contact,
            reference: application[:short_reference]
          ) <> ".pdf"
      )
    )
  end
end
