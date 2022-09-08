defmodule TmdeWeb.ApplicationMailerView do
  use TmdeWeb, :view
  import TmdeWeb.Components.MailerComponents
  import Tmde.Contacts.Contact, only: [greeting: 1]
  import Tmde.Content.Translation, only: [translate: 2]

  def ending() do
    gettext("Sincerely,")
  end

  def sender(%{sender: %{name: name}}), do: name
end
