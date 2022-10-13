defmodule TmdeWeb.Components.ContactComponents do
  use TmdeWeb, :component

  alias Tmde.Contacts.{Contact, Address}

  @spec greeting(any) :: Phoenix.LiveView.Rendered.t()
  def greeting(assigns) do
    ~H"""
    <p><%= Contact.greeting(@contact) %></p>
    """
  end

  def ending(assigns) do
    ~H"""
    <p><%= gettext("Sincerely,") %></p>
    """
  end

  def signature(assigns) do
    pngdata =
      assigns.file_path
      |> File.read!()
      |> Base.encode64()

    ~H"""
    <p class="signature">
      <img src={"data:image/png;base64,#{pngdata}"} alt="Unterschrift Thorsten-Michael Deinert" />
      <%= @sender %>
    </p>
    """
  end

  def address(assigns) do
    contact = assigns[:contact]

    address =
      cond do
        assigns[:address] -> assigns[:address]
        contact -> contact.address
      end

    assigns =
      assigns
      |> assign_defaults(prepend: [])
      |> assign(contact: contact, address: address)

    ~H"""
    <p>
      <%= render_slot(@prepend) %>
      <%= if @contact do %>
        <%= if @contact.title do %>
          <%= @contact.title%><br>
        <% end %>
        <strong><%= @contact %></strong><br>
      <% end %>
      <%= for line <- Address.lines(@address) do %>
        <%= line %><br>
      <% end %>
    </p>
    """
  end
end
