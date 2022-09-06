defmodule Tmde.Contacts.Link do
  use Ecto.Schema
  import TmdeWeb.Gettext
  alias __MODULE__

  embedded_schema do
    field :type, Ecto.Enum, values: [:email, :phone, :mobile, :whatsapp, :website]
    field :target, :string
  end

  def type_to_string(%__MODULE__{type: :phone}), do: gettext("phone")
  def type_to_string(%__MODULE__{type: :mobile}), do: gettext("mobile")
  def type_to_string(%__MODULE__{type: :whatsapp}), do: gettext("whatsapp")
  def type_to_string(%__MODULE__{type: :email}), do: gettext("email")
  def type_to_string(%__MODULE__{type: :website}), do: gettext("web")
  def type_to_string(%__MODULE__{}), do: ""

  defp sanitize_phone_number(target) do
    target
    |> String.replace(~r/[^0-9\+]/, "")
  end

  def sanitize_for_whatsapp(target) do
    target
    |> String.replace(~r/^[^1-9]*/, "")
    |> sanitize_phone_number()
  end

  def build_link_options(%__MODULE__{type: type, target: number})
      when type in [:phone, :mobile] do
    [
      to: "tel:#{sanitize_phone_number(number)}",
      title: gettext("call %{number}...", number: number)
    ]
  end

  def build_link_options(%__MODULE__{type: :email, target: email}) do
    [
      to: "mailto:#{email}",
      title: gettext("mail to %{email}...", email: email)
    ]
  end

  def build_link_options(%__MODULE__{type: :whatsapp, target: target}) do
    [
      to: "https://wa.me/#{sanitize_for_whatsapp(target)}",
      title: gettext("whatsapp to %{number}...", number: target)
    ]
  end

  def build_link_options(%__MODULE__{target: url}) do
    [
      to: "https://#{url}",
      title: gettext("Show %{url} in browser...", url: url)
    ]
  end

  defimpl String.Chars, for: __MODULE__ do
    def to_string(%{type: :website} = link),
      do: "#{Link.type_to_string(link)}: https://#{link.target}"

    def to_string(link), do: "#{Link.type_to_string(link)}: #{link.target}"
  end

  defimpl Phoenix.HTML.Safe, for: __MODULE__ do
    def to_iodata(%{target: target}), do: target
  end
end
