defmodule TmdeWeb.LayoutView do
  use TmdeWeb, :view

  # Phoenix LiveDashboard is available only in development by default,
  # so we instruct Elixir to not warn if the dashboard route is missing.
  @compile {:no_warn_undefined, {Routes, :live_dashboard_path, 2}}

  use Bulma
  import Bulma.Footer
end
