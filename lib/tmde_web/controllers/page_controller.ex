defmodule TmdeWeb.PageController do
  @moduledoc """
  Controller for homepage (index) and different pages that are required on a website, like imprint and privacy policy.
  """
  use TmdeWeb, :controller
  alias Tmde.Helper.Markdown
  import TmdeWeb.Plugs.Page, only: [set_metadata: 2]

  # Include part of repo's README as external resource and convert it into html on compile time
  @readme_contents Markdown.content_to_html!(
                     [de: "content/pages/de/README.md", en: "README.md"],
                     splitter: "INDEX",
                     footnotes: true
                   )

  @privacy_policies Markdown.content_to_html!(
                      de: "content/pages/de/datenschutzerklärung.md",
                      en: "content/pages/en/privacy_policy.md"
                    )

  for %{path: path} <- Keyword.values(@privacy_policies) ++ Keyword.values(@readme_contents) do
    @external_resource path
  end

  @doc "Homepage"
  def index(conn, _params) do
    conn
    |> set_metadata(
      title: "Thorsten-Michael",
      description:
        gettext(
          "Personal homepage of Thorsten-Michael Deinert. Passionate computer scientist, software developer, and programming languages polyglot."
        )
    )
    |> render("index.html",
      readme_content: @readme_contents[:de].html
    )
  end

  def imprint(conn, _params) do
    conn
    |> set_metadata(
      title: gettext("Imprint"),
      description:
        gettext(
          "Imprint and privacy policy for thorsten-michael.de, the personal homepage of Thorsten-Michael Deinert."
        )
    )
    |> render("imprint.html",
      privacy_policy: @privacy_policies[:de].html,
      cookie_data: conn.req_cookies,
      session_data: get_session(conn),
      request_data:
        conn.req_headers
        |> Keyword.take(~w[referer user-agent])
        |> Keyword.put(:"remote ip", conn.remote_ip |> :inet.ntoa())
        |> Keyword.put(:"request path", conn.request_path)
    )
  end
end
