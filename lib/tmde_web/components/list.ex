defmodule TmdeWeb.Components.List do
  use TmdeWeb, :component
  use Bulma

  def property_list(assigns) do
    assigns =
      assigns
      |> assign_defaults(data: [])
      |> assign_class(["property-list"])
      |> prepare_data()

    ~H"""
    <dl class={@class}>
      <%= for {key, value} <- @data do %>
        <dt><%= key %></dt>
        <dd><%= value %></dd>
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
            {Map.get(item, assigns[:key]), Map.get(item, assigns[:value])}
        end
      end

    assigns
    |> assign(:data, data)
  end
end
