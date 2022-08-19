defmodule TmdeWeb.ApplicationMailerView do
  use TmdeWeb, :view
  import TmdeWeb.Components.MailerComponents

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

  def link_to_text(application, {type, {number, _usage}}),
    do: "#{link_type(application, type)}:\t#{number}"

  def link_type(%{locale: locale}, :phone) do
    Gettext.with_locale(locale, fn ->
      gettext("phone")
    end)
  end

  def link_type(%{locale: locale}, :mobile) do
    Gettext.with_locale(locale, fn ->
      gettext("mobile")
    end)
  end

  def link_type(%{locale: locale}, :email) do
    Gettext.with_locale(locale, fn ->
      gettext("email")
    end)
  end
end
