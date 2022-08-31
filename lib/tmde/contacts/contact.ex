defmodule Tmde.Contacts.Contact do
  @moduledoc """
  Provides contact information to applications
  """
  use Ecto.Schema
  import Tmde.Helper.StringHelper
  import TmdeWeb.Gettext
  alias Tmde.Contacts.{Address, Link}
  alias __MODULE__

  embedded_schema do
    field :gender, Ecto.Enum, values: [:male, :female, :unknown], default: :unknown
    field :title, :string
    field :first_name, :string
    field :last_name, :string
    field :email, :string

    embeds_one :address, Address
    embeds_many :links, Link
  end

  def greeting(%__MODULE__{gender: :female, last_name: name}) when is_binary(name) do
    gettext("Dear Mrs. %{name},", name: name)
  end

  def greeting(%__MODULE__{gender: :male, last_name: name}) when is_binary(name) do
    gettext("Dear Mr. %{name},", name: name)
  end

  def greeting(%__MODULE__{}) do
    gettext("Dear Sirs and Madams,")
  end

  def name(%__MODULE__{} = contact) do
    [contact.first_name, contact.last_name]
    |> reject_empty()
    |> Enum.join(" ")
  end

  defimpl String.Chars, for: __MODULE__ do
    def to_string(contact), do: Contact.name(contact)
  end

  defimpl Phoenix.HTML.Safe, for: __MODULE__ do
    def to_iodata(contact), do: to_string(contact)
  end
end
