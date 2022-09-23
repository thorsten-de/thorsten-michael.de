defmodule TmdeWeb.DocumentView do
  use TmdeWeb, :view
  alias TmdeWeb.LayoutView
  alias TmdeWeb.Components.Jobs

  def render_pdf(template, filename, assigns \\ []) do
    html =
      Phoenix.View.render_to_iodata(
        __MODULE__,
        template,
        assigns
        |> Keyword.merge(
          locale: Gettext.get_locale(TmdeWeb.Gettext),
          conn: TmdeWeb.Endpoint,
          layout: {LayoutView, "document.html"}
        )
      )

    path =
      Path.expand([
        Application.get_env(:tmde, :document_root, "tmp/documents/"),
        filename
      ])

    {:html, html}
    |> ChromicPDF.print_to_pdfa(
      print_to_pdf: %{
        scale: 0.6,
        paperWidth: mm(210),
        paperHeight: mm(297),
        marginLeft: mm(16),
        marginTop: mm(10),
        marginRight: mm(12),
        marginBottom: mm(10),
        printBackground: true,
        pagesRanges: "1"
      },
      info: %{
        author: "Thorsten-Michael Deinert",
        creator: "Bewerbungen auf thorsten-michael.de via ChromicPDF",
        title: "CV Thorsten-Michael Deinert",
        subject: "Bewerbungsunterlagen: Elixir-Developer",
        keywords: "CV, Lebenslauf",
        creation_date: Timex.now()
      },
      output: path
    )

    {:ok, path, html}
  end

  defp mm(l), do: l / 25.4

  def generate_cv(application, opts \\ []) do
    qr_code = if opts[:qr_code], do: build_qr_code(application)

    render_pdf(
      "print_cv.html",
      "CV_#{application.id}.pdf",
      application: application,
      qr_code: qr_code
    )
  end

  def generate_cover_letter(application, opts \\ []) do
    qr_code = if opts[:qr_code], do: build_qr_code(application)

    render_pdf(
      "cover_letter.html",
      "cover_letter_#{application.id}.pdf",
      application: application,
      qr_code: qr_code
    )
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
