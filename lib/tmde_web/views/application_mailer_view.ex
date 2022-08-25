defmodule TmdeWeb.ApplicationMailerView do
  use TmdeWeb, :view
  import TmdeWeb.Components.MailerComponents
  alias Tmde.Contact.Link

  def greeting(%{locale: locale, contact: %{gender: "w", name: name}}) when is_binary(name) do
    Gettext.with_locale(locale, fn ->
      gettext("Dear Mrs. %{name},", name: name)
    end)
  end

  def greeting(%{locale: locale, contact: %{gender: "m", name: name}}) when is_binary(name) do
    Gettext.with_locale(locale, fn ->
      gettext("Dear Mr. %{name},", name: name)
    end)
  end

  def greeting(%{locale: locale}) do
    Gettext.with_locale(locale, fn ->
      gettext("Dear Sirs and Madams,")
    end)
  end

  def ending(%{locale: locale}) do
    Gettext.with_locale(locale, fn ->
      gettext("Sincerely,")
    end)
  end

  def sender(%{sender: %{name: name}}), do: name
end
