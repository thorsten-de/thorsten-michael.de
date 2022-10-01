defmodule TmdeWeb.SessionController do
  use TmdeWeb, :controller
  alias TmdeWeb.Plugs.Auth

  def new(conn, _params) do
    conn
    |> render("new.html")
  end

  def create(conn, %{"session" => %{"username" => username, "password" => password}}) do
    case Tmde.Accounts.authenticate(username, password) do
      {:ok, user} ->
        conn
        |> Auth.login(user)
        |> put_flash(:info, gettext("Welcome back, %{username}!", username: username))
        |> redirect(to: Routes.profile_path(conn, :edit))

      {:error, _reason} ->
        conn
        |> put_flash(:error, dgettext("errors", "Invalid username or password"))
        |> render("new.html")
    end
  end

  @spec delete(Plug.Conn.t(), any) :: Plug.Conn.t()
  def delete(conn, _) do
    conn
    |> Auth.logout()
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
