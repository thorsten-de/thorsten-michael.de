defmodule TmdeWeb.Components.ContactComponents do
  use TmdeWeb, :component

  alias Tmde.Contacts.{Contact, Address}

  @spec greeting(map) :: Phoenix.LiveView.Rendered.t()
  @doc """
  Display the letter greeting for a given contact, according
  to the locale currently used
  """
  attr :contact, Contact, required: true

  def greeting(assigns) do
    ~H"""
    <p><%= Contact.greeting(@contact) %></p>
    """
  end

  @spec ending(any) :: Phoenix.LiveView.Rendered.t()
  @doc """
  Display the letter ending formula, according to the
  currently used locale
  """
  def ending(assigns) do
    ~H"""
    <p><%= gettext("Sincerely,") %></p>
    """
  end

  @spec signature(map) :: Phoenix.LiveView.Rendered.t()
  @doc """
  Signs a letter with an image of a signature and places
  the contact's name under it.
  """
  attr :file_path, :string, required: true, doc: "path to the image containing the signature"
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

  @spec address(map) :: Phoenix.LiveView.Rendered.t()
  @doc """
  Display address lines. If a contact is given, the address
  can be pulled from the contact, and the contact's name
  is prepended to the address lines. For additional data,
  a prepend block can be used, e.g. to display the company's
  name above the printed address in a letter.
  """
  attr :contact, Contact, doc: "the name and address lines of the contact are shown"
  attr :address, Address, doc: "Address to be displayed. May be unset if a contact is given"
  slot :prepend, doc: "Information displayed above the contact/address lines"

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
