defmodule TmdeWeb.Plugs.EnsureAuthenticated do
  import Plug.Conn
  alias TmdeWeb.Router.Helpers, as: Routes
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  def init(opts), do: opts

  def call(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(
        :error,
        Gettext.dgettext(TmdeWeb.Gettext, "errors", "You must be logged in to access this page")
      )
      |> redirect(to: Routes.session_path(conn, :new))
      |> halt()
    end
  end
end
