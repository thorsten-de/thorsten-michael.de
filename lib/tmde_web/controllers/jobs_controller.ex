defmodule TmdeWeb.JobsController do
  use TmdeWeb, :controller
  alias TmdeWeb.DocumentView

  alias Tmde.Jobs

  defmodule DocumentNotFoundError do
    defexception [:message, plug_status: 404]
  end

  @possible_slugs ~w[arbeitszeugnis-barbara-reisen diplomzeugnis abiturzeugnis cv anschreiben portfolio]

  def download_document(conn, %{"token" => token, "slug" => slug}) when slug in @possible_slugs do
    with {:ok, id} <- Jobs.Application.token_to_id(token),
         %Jobs.Application{} = application <- Jobs.get_application!(id) do
      document =
        application.documents
        |> Enum.find(&(&1.slug == slug))

      Jobs.log_event!(application, "DOCUMENT_DOWNLOAD", %{
        locale: get_session(conn, :locale),
        token: token,
        slug: slug,
        exists: document != nil
      })

      case document do
        nil ->
          raise DocumentNotFoundError,
                "No document for #{slug} could not be found for this application."

        document ->
          conn
          |> send_download({:file, document.filename}, encode: false)
      end
    end
  end

  def download_document(conn, %{"id" => id, "slug" => slug}) when slug in @possible_slugs do
    application = Jobs.get_application!(id)

    unless application,
      do: raise(DocumentNotFoundError, "No application with this id can be found.")

    document =
      application.documents
      |> Enum.find(&(&1.slug == slug))

    case document do
      nil ->
        raise DocumentNotFoundError,
              "No document for #{slug} could not be found for this application."

      document ->
        conn
        |> send_download({:file, document.filename}, encode: false)
    end
  end

  def download_document(_conn, _params),
    do: raise(DocumentNotFoundError, "No document of this type can be found")

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
