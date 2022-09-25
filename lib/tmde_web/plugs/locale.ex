defmodule TmdeWeb.Plugs.Locale do
  @moduledoc """
  Sets the locale for Gettext and text processing
  """
  import Plug.Conn

  @known_locales Gettext.known_locales(TmdeWeb.Gettext)

  def init(_opts), do: nil

  def call(%Plug.Conn{params: %{"locale" => locale}} = conn, _opts)
      when locale in @known_locales do
    Gettext.put_locale(TmdeWeb.Gettext, locale)

    conn
    |> put_session(:locale, locale)
  end

  def call(conn, _opts) do
    case get_session(conn, :locale) do
      locale when locale in @known_locales ->
        Gettext.put_locale(TmdeWeb.Gettext, locale)

      _other ->
        :noop
    end

    conn
  end
end
