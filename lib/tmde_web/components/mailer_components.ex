defmodule TmdeWeb.Components.MailerComponents do
  @moduledoc """
  Components for building html content for emails
  """
  use TmdeWeb, :component

  @doc """
  A block inside the layout that has content. Assigns are interpreted as styles
  """
  def block(assigns) do
    assigns =
      assigns
      |> assign(:style, to_style(assigns_to_attributes(assigns)))

    ~H"""
    <tr>
      <td style={@style}>
        <%= render_slot(@inner_block) %>
      </td>
    </tr>
    """
  end

  @doc """
  Main content area
  """
  def main_content(assigns) do
    assigns =
      assigns
      |> assign(:style,
        width: "94%",
        "max-width": "600px",
        "text-align": :left,
        "font-family": assigns[:font_family] || "Public Sans,Arial,sans-serif",
        "font-size": assigns[:font_size] || "16px",
        "line-height": "22px",
        color: assigns[:color]
      )

    ~H"""
    <.table>
      <tr>
        <td align="center" style="padding:0;">
          <.ghost_table>
            <.table style={@style}>
              <%= render_slot(@inner_block) %>
            </.table>
          </.ghost_table>
        </td>
      </tr>
    </.table>
    """
  end

  @doc """
  Ghost Tables for Outlook on Windows
  """
  def ghost_table(assigns) do
    ~H"""
    <!--[if mso]>
    <table role="presentation" align="center" style="width:600px;">
    <tr>
    <td>
    <![endif]-->
      <%= render_slot(@inner_block) %>
    <!--[if mso]>
    </td>
    </tr>
    </table>
    <![endif]-->
    """
  end

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
  @doc """
  Builds a table based on default settings, which can be overridden
  """
  def table(assigns) do
    assigns =
      assigns
      |> assign_defaults(@default_table_assigns)
      |> set_style()
      |> set_attributes_from_assigns()

    ~H"""
    <table {@attributes}>
      <%= render_slot(@inner_block) %>
    </table>
    """
  end

  def set_style(assigns) do
    assigns
    |> update(:style, fn style ->
      @default_table_assigns[:style]
      |> Keyword.merge(style)
      |> to_style()
    end)
  end

  @doc """
  converts a keyword list or a map to an inline style definition string
  """
  def to_style(attributes) do
    attributes
    |> Enum.reject(fn {_key, value} -> is_nil(value) end)
    |> Enum.map(fn {key, value} -> "#{key}:#{value};" end)
    |> Enum.join("")
  end
end
