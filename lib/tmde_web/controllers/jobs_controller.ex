defmodule TmdeWeb.JobsController do
  use TmdeWeb, :controller
  alias TmdeWeb.DocumentView

  alias Tmde.Jobs

  def cv_pdf(conn, %{"id" => application_id}) do
    application = Jobs.get_application!(application_id)
    DocumentView.ensure_path_exists!(["test"])

    {:ok, path, _html} =
      DocumentView.generate_cv(
        application,
        DocumentView.document_filepath(["test"], "CV.pdf")
      )

    conn
    |> send_download({:file, path})

    # |> html(html)
  end

  @spec cover_letter_pdf(Plug.Conn.t(), map) :: Plug.Conn.t()
  def cover_letter_pdf(conn, %{"id" => application_id}) do
    application = Jobs.get_application!(application_id)
    DocumentView.ensure_path_exists!(["test"])

    {:ok, path, _html} =
      DocumentView.generate_cover_letter(
        application,
        DocumentView.document_filepath(["test"], "cover_letter.pdf"),
        qr_code: true
      )

    conn
    |> send_download({:file, path})

    # |> html(html)
  end
end
