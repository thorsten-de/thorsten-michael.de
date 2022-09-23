defmodule TmdeWeb.JobsController do
  use TmdeWeb, :controller
  alias TmdeWeb.DocumentView

  alias Tmde.Jobs

  def cv_pdf(conn, %{"id" => application_id}) do
    application = Jobs.get_application!(application_id)

    {:ok, _path, html} = DocumentView.generate_cv(application, qr_code: true)

    conn
    |> html(html)
  end

  def cover_letter_pdf(conn, %{"id" => application_id}) do
    application = Jobs.get_application!(application_id)

    {:ok, _path, html} = DocumentView.generate_cover_letter(application, qr_code: true)

    conn
    |> html(html)
  end
end
