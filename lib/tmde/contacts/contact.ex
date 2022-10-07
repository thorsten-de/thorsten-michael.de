defmodule Tmde.Contacts.Contact do
  @moduledoc """
  Provides contact information to applications
  """
  use Tmde, :schema
  import Tmde.Helper.StringHelper
  import TmdeWeb.Gettext
  alias Tmde.Contacts.Address
  alias __MODULE__

  @all_genders [male: gettext("male"), female: gettext("female"), unknown: gettext("other")]
  embedded_schema do
    field :gender, Ecto.Enum, values: Keyword.keys(@all_genders), default: :unknown
    field :title, :string
    field :first_name, :string
    field :last_name, :string
    field :email, :string

    embeds_one :address, Address
  end

  def all_genders() do
    @all_genders
  end

  def changeset(contact, attr \\ %{}) do
    contact
    |> cast(attr, [:gender, :title, :first_name, :last_name, :email])
    |> validate_required([:gender, :email])
    |> cast_embed(:address)
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

  def short_name(%__MODULE__{} = contact) do
    [get_initials(contact), contact.last_name]
    |> reject_empty()
    |> Enum.join(" ")
  end

  defp get_initials(contact) do
    case contact.first_name do
      "" -> ""
      name when is_binary(name) -> String.slice(name, 0..0) <> "."
      _ -> ""
    end
  end

  def address_line(contact, opts \\ []) do
    splitter = opts[:splitter] || " | "

    [short_name(contact) | Address.lines(contact.address)]
    |> Enum.join(splitter)
  end

  defimpl String.Chars, for: __MODULE__ do
    def to_string(contact), do: Contact.name(contact)
  end

  defimpl Phoenix.HTML.Safe, for: __MODULE__ do
    def to_iodata(contact), do: to_string(contact)
  end
end
