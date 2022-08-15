defmodule TmdeWeb.Plugs.Page do
  @moduledoc """
  Plug that handles metadata for pages
  """

  defstruct locale: "de",
            author: "Thorsten-Michael Deinert",
            description: ""

  ## TODO: Make it a proper plug that takes part in the browser pipeline and add
  ## helper functions for pipelining conn in controller/live component before render
end
