defmodule TmdeWeb.PageController do
  @moduledoc """
  Controller for homepage (index) and different pages that are required on a website, like imprint and privacy policy.
  """
  use TmdeWeb, :controller
  alias Tmde.Helper.Markdown

  # Include part of repo's README as external resource and convert it into html on compile time
  @external_resource Path.expand("README.md")

  @readme_content Markdown.file_to_html(Path.expand("README.md"),
                    splitter: "INDEX",
                    footnotes: true
                  )

  @doc "Homepage"
  def index(conn, _params) do
    render(conn, "index.html", readme_content: @readme_content)
  end
end
