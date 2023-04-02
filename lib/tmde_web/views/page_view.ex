defmodule TmdeWeb.PageView do
  use TmdeWeb, :view
  use Bulma
  alias TmdeWeb.Components
  alias Components.Blog
  import Components.List, only: [property_list: 1]
end
