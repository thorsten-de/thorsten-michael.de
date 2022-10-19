defmodule TmdeWeb.LocaleLive do
  import Phoenix.Component, only: [assign: 2]

  def on_mount(:default, _params, %{"locale" => locale}, socket) do
    Gettext.put_locale(TmdeWeb.Gettext, locale)
    {:cont, assign(socket, locale: locale)}
  end

  def on_mount(:default, _, _, socket), do: {:cont, socket}
end
