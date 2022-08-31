defmodule TmdeWeb.ApplicationMailerView do
  use TmdeWeb, :view
  import TmdeWeb.Components.MailerComponents
  alias Tmde.Contacts.Link
  import Tmde.Contacts.Contact, only: [greeting: 1]

  def ending(%{locale: locale}) do
    Gettext.with_locale(locale, fn ->
      gettext("Sincerely,")
    end)
  end

  def sender(%{sender: %{name: name}}), do: name
end
