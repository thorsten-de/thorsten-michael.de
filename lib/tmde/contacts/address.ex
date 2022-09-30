defmodule Tmde.Contacts.Address do
  @moduledoc """
  A contacts address
  """
  use Tmde, :schema
  import Tmde.Helper.StringHelper
  alias Tmde.Contacts.{Country, Contact}
  alias __MODULE__

  embedded_schema do
    field :name_suffix, :string
    field :street, :string
    field :zip, :string
    field :city, :string
    field :country, Country, default: Country.default()

    belongs_to :contact, Contact
  end

  def changeset(data, attr \\ %{}) do
    data
    |> cast(attr, [:name_suffix, :street, :zip, :city, :country])
    |> validate_required([:street, :zip, :city, :country])
    |> validate_zip_code()
  end

  @doc """
  The format of the zip code can be checked with a regex set for the country. If no
  validator is provided, nothing happens
  """
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

  def lines(nil), do: []

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
