defmodule TmdeWeb.Components.MailerComponents do
  use TmdeWeb, :component

  @default_table_assigns [
    role: "presentation",
    style: [
      width: "100%",
      "border-collapse": "collapse",
      border: 0,
      "border-spacing": 0
    ],
    inner_block: []
  ]

  def table(assigns) do
    assigns =
      assigns
      |> assign_defaults(@default_table_assigns)
      |> update(:style, fn style ->
        @default_table_assigns[:style]
        |> Keyword.merge(style)
      end)

    ~H"""
      <table style={to_style(@style)} role={@role}>
        <%= render_slot(@inner_block) %>
      </table>

    """
  end

  defp assign_defaults(assigns, defaults) do
    defaults
    |> Enum.reduce(assigns, fn {key, value}, acc ->
      assign_new(acc, key, fn -> value end)
    end)
  end

  def to_style(attributes) do
    attributes
    |> Enum.reject(fn {_key, value} -> is_nil(value) end)
    |> Enum.map(fn {key, value} -> "#{key}:#{value};" end)
    |> Enum.join("")
  end
end
