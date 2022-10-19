defmodule TmdeWeb.Components.ContactComponents do
  use TmdeWeb, :component

  alias Tmde.Contacts.{Contact, Address}

  attr :contact, Contact, required: true

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

  attr :file_path, :string, required: true
  attr :sender, Contact, required: true

  def signature(assigns) do
    pngdata =
      assigns.file_path
      |> File.read!()
      |> Base.encode64()

    assigns =
      assigns
      |> assign(data: pngdata)

    ~H"""
    <p class="signature">
      <img src={"data:image/png;base64,#{@data}"} alt="Unterschrift Thorsten-Michael Deinert" />
      <%= @sender %>
    </p>
    """
  end

  attr :contact, Contact
  attr :address, Address
  slot :prepend

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
