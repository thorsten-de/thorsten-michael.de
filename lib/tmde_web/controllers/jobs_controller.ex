defmodule TmdeWeb.JobsController do
  use TmdeWeb, :controller
  alias TmdeWeb.DocumentView

  alias Tmde.Jobs

  def cv_pdf(conn, %{"id" => application_id}) do
    application = Jobs.get_application!(application_id)

    {:ok, path} = DocumentView.generate_cv(application, qr_code: true)

    conn
    |> send_download({:file, path})
  end
end
