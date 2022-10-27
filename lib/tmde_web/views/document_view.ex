defmodule TmdeWeb.DocumentView do
  use TmdeWeb, :view
  use Bulma
  alias TmdeWeb.LayoutView
  alias TmdeWeb.Components.{Jobs}

  import TmdeWeb.Components.{ContactComponents}
  import TmdeWeb.Components.Jobs, only: [qr_code: 1]
  import TmdeWeb.ComponentHelpers
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
          marginTop: mm(16),
          marginRight: mm(12),
          marginBottom: mm(10),
          printBackground: true,
          pageRanges: "1"
        },
        info: %{
          author: "Thorsten-Michael Deinert",
          creator: "Bewerbungen auf thorsten-michael.de via ChromicPDF",
          title: "CV Thorsten-Michael Deinert",
          subject: "CV Thorsten-Michael Deinert",
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
    token = Tmde.Jobs.Application.sign_token(application)
    qr_code = if opts[:qr_code], do: build_qr_code(token)

    render_pdf(
      "cover_letter.html",
      filename,
      print: [
        print_to_pdf: %{
          paperWidth: mm(210),
          paperHeight: mm(297),
          marginLeft: mm(20),
          marginTop: mm(10),
          marginRight: mm(20),
          marginBottom: mm(0),
          printBackground: true,
          pageRanges: "1"
        },
        info: %{
          author: "Thorsten-Michael Deinert",
          creator: "Bewerbungen auf thorsten-michael.de via ChromicPDF",
          title: opts[:subject] || "Bewerbung von Thorsten-Michael Deinert",
          subject: opts[:subject] || "Bewerbung von Thorsten-Michael Deinert",
          keywords: "Anschreiben, Cover letter",
          creation_date: Timex.now()
        }
      ],
      assigns: [
        application: application,
        qr_code: qr_code,
        token: token,
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
      %{
        slug: "arbeitszeugnis-barbara-reisen",
        label: gettext("Reference %{company_name}", company_name: "Barbara Reisen"),
        filename:
          document_filepath(["common"], "Arbeitszeugnis Barbara Reisen Thorsten Deinert.pdf")
      },
      %{
        slug: "diplomzeugnis",
        label: gettext("Diploma certificate"),
        filename: document_filepath(["common"], "Diplomzeugnis Thorsten Deinert.pdf")
      },
      %{
        slug: "abiturzeugnis",
        label: gettext("Graduation diploma"),
        filename: document_filepath(["common"], "Abiturzeugnis Thorsten Deinert.pdf")
      }
    ]
  end

  def generate_documents(%Tmde.Jobs.Application{id: uuid} = application) do
    ensure_path_exists!([uuid])

    documents =
      Gettext.with_locale(TmdeWeb.Gettext, application.locale, fn ->
        {:ok, cv_file, _hmtl} =
          generate_cv(
            application,
            document_filepath([application.id], "CV #{application.job_seeker.contact}.pdf")
          )

        documents = [
          %{slug: "cv", label: gettext("CV"), filename: cv_file}
          | default_documents()
        ]

        title = "#{application.job_seeker.contact} - #{translate(application.subject)}"

        {:ok, letter_file, _html} =
          generate_cover_letter(
            application,
            document_filepath(
              [uuid],
              "#{title}.pdf"
            ),
            qr_code: true,
            subject: title,
            attachments: Enum.map(documents, & &1.label)
          )

        [
          %{slug: "anschreiben", label: gettext("Cover Letter"), filename: letter_file}
          | documents
        ]
      end)

    portfolio_file =
      document_filepath([uuid], "#{gettext("Portfolio")} #{application.job_seeker.contact}.pdf")

    System.cmd("pdfunite", Enum.map(documents, & &1.filename) ++ [portfolio_file])

    [
      %{slug: "portfolio", label: gettext("Portfolio"), filename: portfolio_file}
      | documents
    ]
  end

  # Generate QR-Code and assign it to the socket. Only needed in print layout
  @settings %QRCode.SvgSettings{qrcode_color: {54, 54, 54}}

  defp build_qr_code(token) do
    with {:ok, code} <-
           TmdeWeb.Endpoint
           |> Routes.jobs_url(:show, token)
           |> QRCode.create(:low),
         svg_data <- QRCode.Svg.to_base64(code, @settings) do
      svg_data
    else
      _ -> nil
    end
  end
end
