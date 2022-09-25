defmodule TmdeWeb.DeliveryController do
  use TmdeWeb, :controller

  alias Tmde.Jobs
  alias Tmde.Jobs.Delivery

  @doc """
  Returns the usual logo, but can log the request. Tracks request
  for logo from emails when external images are enabled.
  """
  def logo_logger(conn, params) do
    with token when not is_nil(token) <- params["mailId"],
         {:ok, id} <- Delivery.token_to_id(token),
         %Delivery{} = delivery <- Jobs.get_delivery(id) do
      Jobs.create_delivery_tracking(delivery,
        payload: %{
          "referer" => get_req_header(conn, "referer"),
          "user-agent" => get_req_header(conn, "user-agent"),
          "remote-ip" => conn.remote_ip |> :inet.ntoa() |> to_string()
        }
      )
    end

    filename = Application.app_dir(:tmde, "priv/static/images/logos/tmd-slogan-120h.svg")

    conn
    |> send_download({:file, filename},
      disposition: :inline,
      filename: "tmd-logo.svg"
    )
  end
end
