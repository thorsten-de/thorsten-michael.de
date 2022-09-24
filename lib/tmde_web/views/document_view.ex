defmodule TmdeWeb.DocumentView do
  use TmdeWeb, :view
  use Bulma
  alias TmdeWeb.LayoutView
  alias TmdeWeb.Components.{Jobs}

  import TmdeWeb.Components.{ContactComponents, ContentComponents}
  import TmdeWeb.Components.Jobs, only: [qr_code: 1]
  alias Tmde.Contacts.Link, as: ContactLink
  alias Tmde.Contacts.Contact

  def render_pdf(template, filename, options \\ []) do
    layout =
      case options[:layout] do
        false -> false
        nil -> {LayoutView, "document.html"}
        other -> other
      end

    html =
      Phoenix.View.render_to_iodata(
        __MODULE__,
        template,
        options[:assigns]
        |> Keyword.merge(
          locale: Gettext.get_locale(TmdeWeb.Gettext),
          conn: TmdeWeb.Endpoint,
          layout: layout
        )
      )

    {:html, html}
    |> ChromicPDF.print_to_pdfa(
      Keyword.merge(
        options[:print],
        output: filename
      )
    )

    {:ok, filename, html}
  end

  defp mm(l), do: l / 25.4

  def generate_cv(application, filename, _opts \\ []) do
    render_pdf(
      "print_cv.html",
      filename,
      print: [
        print_to_pdf: %{
          scale: 0.6,
          paperWidth: mm(210),
          paperHeight: mm(297),
          marginLeft: mm(16),
          marginTop: mm(10),
          marginRight: mm(12),
          marginBottom: mm(10),
          printBackground: true,
          pageRanges: "1"
        },
        info: %{
          author: "Thorsten-Michael Deinert",
          creator: "Bewerbungen auf thorsten-michael.de via ChromicPDF",
          title: "CV Thorsten-Michael Deinert",
          subject: "Bewerbungsunterlagen: Elixir-Developer",
          keywords: "CV, Lebenslauf",
          creation_date: Timex.now()
        }
      ],
      assigns: [
        application: application
      ],
      layout: false
    )
  end

  def generate_cover_letter(application, filename, opts \\ []) do
    qr_code = if opts[:qr_code], do: build_qr_code(application)

    render_pdf(
      "cover_letter.html",
      filename,
      print: [
        print_to_pdf: %{
          paperWidth: mm(210),
          paperHeight: mm(297),
          marginLeft: mm(25),
          marginTop: mm(20),
          marginRight: mm(25),
          marginBottom: mm(20),
          printBackground: true,
          pageRanges: "1"
        },
        info: %{
          author: "Thorsten-Michael Deinert",
          creator: "Bewerbungen auf thorsten-michael.de via ChromicPDF",
          title: "CV Thorsten-Michael Deinert",
          subject: "Bewerbungsunterlagen: Elixir-Developer",
          keywords: "CV, Lebenslauf",
          creation_date: Timex.now()
        }
      ],
      assigns: [
        application: application,
        qr_code: qr_code,
        token: Tmde.Jobs.Application.sign_token(application),
        attachments: opts[:attachments] || []
      ]
    )
  end

  def ensure_path_exists!(path) do
    path = document_path(path)

    unless File.dir?(path) do
      File.mkdir_p!(path)
    end
  end

  def document_path(filepath \\ []),
    do:
      Path.join([
        Application.get_env(:tmde, :document_root, "tmp/documents/")
        | filepath
      ])

  def document_filepath(filepath \\ [], filename),
    do: Path.join(document_path(filepath), filename) |> Path.absname()

  def default_documents do
    [
      {gettext("Diploma certificate"),
       document_filepath(["common"], "Diplomzeugnis_Thorsten_Deinert.pdf")},
      {gettext("Graduation diploma"),
       document_filepath(["common"], "Abiturzeugnis_Thorsten_Deinert.pdf")}
    ]
  end

  def generate_portfolio(%Tmde.Jobs.Application{id: uuid} = application) do
    ensure_path_exists!([uuid])

    {:ok, cv_file, _hmtl} =
      generate_cv(
        application,
        document_filepath([application.id], "CV.pdf")
      )

    documents = [{gettext("CV"), cv_file} | default_documents()]

    {:ok, letter_file, _html} =
      generate_cover_letter(
        application,
        document_filepath([uuid], "cover_letter.pdf"),
        qr_code: true,
        attachments: Enum.map(documents, &elem(&1, 0))
      )

    documents = [{gettext("Cover Letter"), letter_file} | documents]

    portfolio_file = document_filepath([uuid], "portfolio.pdf")
    System.cmd("pdfunite", Enum.map(documents, &elem(&1, 1)) ++ [portfolio_file])

    documents =
      [{gettext("Portfolio"), portfolio_file} | documents]
      |> IO.inspect()

    :ok
  end

  # Generate QR-Code and assign it to the socket. Only needed in print layout
  @settings %QRCode.SvgSettings{qrcode_color: {54, 54, 54}}

  defp build_qr_code(application) do
    with {:ok, code} <-
           TmdeWeb.Endpoint
           |> Routes.jobs_url(:show, application)
           |> QRCode.create(:low),
         svg_data <- QRCode.Svg.to_base64(code, @settings) do
      svg_data
    else
      _ -> nil
    end
  end
end
