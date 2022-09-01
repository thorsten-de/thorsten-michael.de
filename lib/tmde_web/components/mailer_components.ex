defmodule TmdeWeb.Components.MailerComponents do
  @moduledoc """
  Components for building html content for emails
  """
  use TmdeWeb, :component

  @width 600
  @padding 30

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

  def columns(assigns) do
    assigns =
      assigns
      |> assign_defaults(
        style: [
          display: "inline-block",
          width: "100%",
          "font-size": "1rem"
        ],
        v_padding: "#{@padding}px",
        default_column_width: "#{(@width - 2 * @padding) / length(assigns.column)}px"
      )

    ~H"""
    <.block padding={"20px #{@v_padding}"} font-size="0">
      <!--[if mso]>
      <table role="presentation" width="100%">
      <tr>
        <%= for col <- @column do %>
          <%
            column_width = Map.get(col, :width, @default_column_width)
            vertical_align = Map.get(col, :"vertical-align", "top")
            text_align = Map.get(col, :"text-align")
          %>
          <td style="<%= to_style(width: column_width) %>" align="<%= text_align %>" valign="<%= vertical_align %>">
            <![endif]-->
              <div class="col" style={to_style(@style, "max-width": column_width, "vertical-align": vertical_align, "text-align": text_align)}>
                <%= render_slot(col) %>
              </div>
            <!--[if mso]>
          </td>
        <% end %>
      </tr>
      </table>
      <![endif]-->
    </.block>
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
        "margin-top": "20px",
        "max-width": "#{@width}px",
        "text-align": :left,
        "font-family": assigns[:font_family] || "Public Sans,Arial,sans-serif",
        "font-size": assigns[:font_size] || "16px",
        "line-height": "22px",
        background: assigns[:background],
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

  def bi_icon(assigns) do
    assigns =
      assigns
      |> assign_defaults(
        size: 16,
        color: "currentColor",
        style: to_style(display: "inline-block", "vertical-align": "middle", padding: 2)
      )

    icon(assigns)
  end

  @doc """
  Render an svg icon (taken from Bootstrap Icons font, https://icons.getbootstrap.com)
  directly inside the mail
  """
  def icon(%{icon: :whatsapp} = assigns) do
    ~H"""
    <svg style={@style} xmlns="http://www.w3.org/2000/svg" width={@size} height={@size} fill={@color} class="bi bi-whatsapp" viewBox="0 0 16 16">
      <path d="M13.601 2.326A7.854 7.854 0 0 0 7.994 0C3.627 0 .068 3.558.064 7.926c0 1.399.366 2.76 1.057 3.965L0 16l4.204-1.102a7.933 7.933 0 0 0 3.79.965h.004c4.368 0 7.926-3.558 7.93-7.93A7.898 7.898 0 0 0 13.6 2.326zM7.994 14.521a6.573 6.573 0 0 1-3.356-.92l-.24-.144-2.494.654.666-2.433-.156-.251a6.56 6.56 0 0 1-1.007-3.505c0-3.626 2.957-6.584 6.591-6.584a6.56 6.56 0 0 1 4.66 1.931 6.557 6.557 0 0 1 1.928 4.66c-.004 3.639-2.961 6.592-6.592 6.592zm3.615-4.934c-.197-.099-1.17-.578-1.353-.646-.182-.065-.315-.099-.445.099-.133.197-.513.646-.627.775-.114.133-.232.148-.43.05-.197-.1-.836-.308-1.592-.985-.59-.525-.985-1.175-1.103-1.372-.114-.198-.011-.304.088-.403.087-.088.197-.232.296-.346.1-.114.133-.198.198-.33.065-.134.034-.248-.015-.347-.05-.099-.445-1.076-.612-1.47-.16-.389-.323-.335-.445-.34-.114-.007-.247-.007-.38-.007a.729.729 0 0 0-.529.247c-.182.198-.691.677-.691 1.654 0 .977.71 1.916.81 2.049.098.133 1.394 2.132 3.383 2.992.47.205.84.326 1.129.418.475.152.904.129 1.246.08.38-.058 1.171-.48 1.338-.943.164-.464.164-.86.114-.943-.049-.084-.182-.133-.38-.232z"/>
    </svg>
    """
  end

  def icon(%{icon: :phone} = assigns) do
    ~H"""
    <svg style={@style} xmlns="http://www.w3.org/2000/svg" width={@size} height={@size} fill={@color} class="bi bi-telephone" viewBox="0 0 16 16">
      <path d="M3.654 1.328a.678.678 0 0 0-1.015-.063L1.605 2.3c-.483.484-.661 1.169-.45 1.77a17.568 17.568 0 0 0 4.168 6.608 17.569 17.569 0 0 0 6.608 4.168c.601.211 1.286.033 1.77-.45l1.034-1.034a.678.678 0 0 0-.063-1.015l-2.307-1.794a.678.678 0 0 0-.58-.122l-2.19.547a1.745 1.745 0 0 1-1.657-.459L5.482 8.062a1.745 1.745 0 0 1-.46-1.657l.548-2.19a.678.678 0 0 0-.122-.58L3.654 1.328zM1.884.511a1.745 1.745 0 0 1 2.612.163L6.29 2.98c.329.423.445.974.315 1.494l-.547 2.19a.678.678 0 0 0 .178.643l2.457 2.457a.678.678 0 0 0 .644.178l2.189-.547a1.745 1.745 0 0 1 1.494.315l2.306 1.794c.829.645.905 1.87.163 2.611l-1.034 1.034c-.74.74-1.846 1.065-2.877.702a18.634 18.634 0 0 1-7.01-4.42 18.634 18.634 0 0 1-4.42-7.009c-.362-1.03-.037-2.137.703-2.877L1.885.511z"/>
    </svg>
    """
  end

  def icon(%{icon: :mobile} = assigns) do
    ~H"""
    <svg style={@style} xmlns="http://www.w3.org/2000/svg" width={@size} height={@size} fill={@color} class="bi bi-phone" viewBox="0 0 16 16">
      <path d="M11 1a1 1 0 0 1 1 1v12a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1h6zM5 0a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H5z"/>
      <path d="M8 14a1 1 0 1 0 0-2 1 1 0 0 0 0 2z"/>
    </svg>
    """
  end

  def icon(%{icon: :email} = assigns) do
    ~H"""
    <svg style={@style} xmlns="http://www.w3.org/2000/svg" width={@size} height={@size} fill={@color} class="bi bi-envelope" viewBox="0 0 16 16">
      <path d="M0 4a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V4Zm2-1a1 1 0 0 0-1 1v.217l7 4.2 7-4.2V4a1 1 0 0 0-1-1H2Zm13 2.383-4.708 2.825L15 11.105V5.383Zm-.034 6.876-5.64-3.471L8 9.583l-1.326-.795-5.64 3.47A1 1 0 0 0 2 13h12a1 1 0 0 0 .966-.741ZM1 11.105l4.708-2.897L1 5.383v5.722Z"/>
    </svg>
    """
  end

  def icon(%{icon: :website} = assigns) do
    ~H"""
    <svg style={@style} xmlns="http://www.w3.org/2000/svg" width={@size} height={@size} fill={@color} class="bi bi-globe" viewBox="0 0 16 16">
      <path d="M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8zm7.5-6.923c-.67.204-1.335.82-1.887 1.855A7.97 7.97 0 0 0 5.145 4H7.5V1.077zM4.09 4a9.267 9.267 0 0 1 .64-1.539 6.7 6.7 0 0 1 .597-.933A7.025 7.025 0 0 0 2.255 4H4.09zm-.582 3.5c.03-.877.138-1.718.312-2.5H1.674a6.958 6.958 0 0 0-.656 2.5h2.49zM4.847 5a12.5 12.5 0 0 0-.338 2.5H7.5V5H4.847zM8.5 5v2.5h2.99a12.495 12.495 0 0 0-.337-2.5H8.5zM4.51 8.5a12.5 12.5 0 0 0 .337 2.5H7.5V8.5H4.51zm3.99 0V11h2.653c.187-.765.306-1.608.338-2.5H8.5zM5.145 12c.138.386.295.744.468 1.068.552 1.035 1.218 1.65 1.887 1.855V12H5.145zm.182 2.472a6.696 6.696 0 0 1-.597-.933A9.268 9.268 0 0 1 4.09 12H2.255a7.024 7.024 0 0 0 3.072 2.472zM3.82 11a13.652 13.652 0 0 1-.312-2.5h-2.49c.062.89.291 1.733.656 2.5H3.82zm6.853 3.472A7.024 7.024 0 0 0 13.745 12H11.91a9.27 9.27 0 0 1-.64 1.539 6.688 6.688 0 0 1-.597.933zM8.5 12v2.923c.67-.204 1.335-.82 1.887-1.855.173-.324.33-.682.468-1.068H8.5zm3.68-1h2.146c.365-.767.594-1.61.656-2.5h-2.49a13.65 13.65 0 0 1-.312 2.5zm2.802-3.5a6.959 6.959 0 0 0-.656-2.5H12.18c.174.782.282 1.623.312 2.5h2.49zM11.27 2.461c.247.464.462.98.64 1.539h1.835a7.024 7.024 0 0 0-3.072-2.472c.218.284.418.598.597.933zM10.855 4a7.966 7.966 0 0 0-.468-1.068C9.835 1.897 9.17 1.282 8.5 1.077V4h2.355z"/>
    </svg>
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

  def to_style(attributes, more_attributes) do
    attributes
    |> Keyword.merge(more_attributes)
    |> to_style()
  end
end
