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
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid username or password")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> Auth.logout()
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
