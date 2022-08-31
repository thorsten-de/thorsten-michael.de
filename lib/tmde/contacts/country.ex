defmodule Tmde.Contacts.Country do
  @moduledoc """
  Countries for use in Contacts. Implemented as custom Ecto Type backed by
  compile-time static data. If given, zip_validator is used in Address to validate
  the zip code.

  If something more dynamic is needed, if would be a nice use case for an agent
  handling the country data at runtime.
  """

  defstruct [:iso, :title, :alias, :zip_validator]

  @known_isos ~w[de]

  def all do
    @known_isos |> Enum.map(&get/1)
  end

  # some static country data

  def get("de"),
    do: %__MODULE__{
      iso: "de",
      title: "Deutschland",
      zip_validator: ~r/^\d{5}$/
    }

  def get("pl"),
    do: %__MODULE__{
      iso: "pl",
      title: "Polen",
      zip_validator: ~r/^\d{2}-\d{3}$/
    }

  # static default country

  def default, do: get("de")

  use Ecto.Type
  @spec type :: :string
  def type, do: :string

  def cast(string) when is_binary(string) do
    {:ok, get(string)}
  end

  def cast(atom) when is_atom(atom) do
    {:ok, atom |> Atom.to_string() |> get}
  end

  def cast(%__MODULE__{} = country) do
    {:ok, country}
  end

  def cast(_), do: :error

  def load(string), do: {:ok, get(string)}

  def dump(%__MODULE__{iso: iso}), do: {:ok, iso}
  def dump(string) when is_binary(string), do: {:ok, string}
  def dump(_), do: :error

  defimpl String.Chars, for: __MODULE__ do
    def to_string(%{title: title}), do: title
  end
end
