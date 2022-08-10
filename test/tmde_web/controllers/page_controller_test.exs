defmodule TmdeWeb.PageControllerTest do
  use TmdeWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Willkommen"
  end

  test "GET /impressum", %{conn: conn} do
    conn = get(conn, "/impressum")
    response = html_response(conn, 200)
    assert response =~ "Thorsten-Michael Deinert"
    assert response =~ "Impressum"
  end
end
