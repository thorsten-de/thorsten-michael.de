defmodule TmdeWeb.PageController do
  @moduledoc """
  Controller for homepage (index) and different pages that are required on a website, like imprint and privacy policy.
  """
  use TmdeWeb, :controller
  alias Tmde.Helper.Markdown

  # Include part of repo's README as external resource and convert it into html on compile time
  @readme_contents Markdown.content_to_html!(
                     [de: "content/pages/de/README.md.eex", en: "README.md"],
                     splitter: "INDEX",
                     footnotes: true
                   )

  @privacy_policies Markdown.content_to_html!(
                      de: "content/pages/de/datenschutzerklärung.md.eex",
                      en: "content/pages/en/privacy_policy.md.eex"
                    )

  for %{path: path} <- Keyword.values(@privacy_policies) ++ Keyword.values(@readme_contents) do
    @external_resource path
  end

  @doc "Homepage"
  def index(conn, _params) do
    render(conn, "index.html", readme_content: @readme_contents[:de].html)
  end

  def imprint(conn, _params) do
    render(conn, "imprint.html",
      page_title: gettext("Imprint"),
      privacy_policy: @privacy_policies[:de].html
    )
  end
end
