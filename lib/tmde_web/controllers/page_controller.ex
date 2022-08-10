defmodule TmdeWeb.PageController do
  @moduledoc """
  Controller for homepage (index) and different pages that are required on a website, like imprint and privacy policy.
  """
  use TmdeWeb, :controller
  alias Tmde.Helper.Markdown

  # Include part of repo's README as external resource and convert it into html on compile time

  @readme_contents [de: "content/pages/de/README.md.eex", en: "README.md"]
                   |> Enum.map(fn
                     {lang, file} ->
                       path = Path.expand(file)
                       @external_resource path
                       {lang,
                        Markdown.file_to_html!(path,
                          splitter: "INDEX",
                          footnotes: true
                        )}
                   end)

  @privacy_policies [
                      de: "content/pages/de/datenschutzerklärung.md.eex",
                      en: "content/pages/en/privacy_policy.md.eex"
                    ]
                    |> Enum.map(fn
                      {lang, file} ->
                        path = Path.expand(file)

                        @external_resource path
                        {lang, Markdown.file_to_html!(path)}
                    end)

  @doc "Homepage"
  def index(conn, _params) do
    render(conn, "index.html", readme_content: @readme_contents[:de])
  end

  def imprint(conn, _params) do
    render(conn, "imprint.html",
      page_title: gettext("Imprint"),
      privacy_policy: @privacy_policies[:de]
    )
  end
end
