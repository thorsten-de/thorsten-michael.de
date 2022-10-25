defmodule TmdeWeb.Components.List do
  use TmdeWeb, :component
  use Bulma


  @spec property_list(map) :: Phoenix.LiveView.Rendered.t()
  @doc """
  A list of keywords and values, shown as html dl block. Class
  `property-list` is used to place keys and values in columns.
  """
  attr :data, :list, required: true
  attr :class, :any
  slot :inner_block

  def property_list(assigns) do
    assigns =
      assigns
      |> assign_class(["property-list"])
      |> prepare_data()

    ~H"""
    <dl class={@class}>
      <%= for {key, value} <- @data do %>
        <dt><%= key %></dt>
        <dd>
          <%= render_slot(@inner_block, value) || value %>
        </dd>
      <% end %>
    </dl>
    """
  end

  defp prepare_data(assigns) do
    data =
      for item <- assigns.data do
        cond do
          is_tuple(item) ->
            item

          is_map(item) ->
            {Map.get(item, assigns[:key]), Map.get(item, assigns[:value], item)}
        end
      end

    assigns
    |> assign(:data, data)
  end
end
