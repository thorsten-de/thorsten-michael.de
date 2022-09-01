defmodule TmdeWeb.JobsController do
  use TmdeWeb, :controller

  @doc """
  Returns the usual logo, but can log the request. Tracks request
  for logo from emails when external images are enabled.
  """
  def logo_logger(conn, %{"id" => id}) do
    IO.inspect(id, label: "Logo requested")
    filename = Application.app_dir(:tmde, "priv/static/images/logos/tmd-slogan-120h.svg")

    conn
    |> send_download({:file, filename},
      disposition: :inline,
      filename: "tmd-logo.svg"
    )
  end
end
