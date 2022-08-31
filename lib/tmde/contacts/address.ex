defmodule Tmde.Contacts.Address do
  @moduledoc """
  A contacts address
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Tmde.Helper.StringHelper
  alias Tmde.Contacts.Contact
  alias __MODULE__

  embedded_schema do
    field :name_suffix, :string
    field :street, :string
    field :zip, :string
    field :city, :string
    field :country, Tmde.Contacts.Country

    belongs_to :contact, Contact
  end

  def changeset(data, attr \\ %{}) do
    data
    |> cast(attr, [:name_suffix, :street, :zip, :city, :country])
    |> validate_required([:street, :zip, :city, :country])
    |> validate_zip_code()
  end

  def validate_zip_code(cs) do
    with %{zip_validator: regex} when not is_nil(regex) <- get_field(cs, :country) do
      cs
      |> validate_format(:zip, regex)
    else
      _ -> cs
    end
  end

  def lines(%__MODULE__{} = address) do
    [address.name_suffix, address.street, "#{address.zip} #{address.city}"]
    |> reject_empty()
  end

  defimpl String.Chars, for: __MODULE__ do
    def to_string(address) do
      address
      |> Address.lines()
      |> Enum.join("\n")
    end
  end

  defimpl Phoenix.HTML.Safe, for: __MODULE__ do
    def to_iodata(address) do
      address
      |> Address.lines()
      |> Enum.join("<br>")
    end
  end
end
