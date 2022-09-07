defmodule Tmde.Content.Translation do
  @moduledoc """
  An embed that represents content in a specific language
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :lang, Ecto.Enum, values: [:de, :en], default: :de
    field :content, :string
  end

  def changeset(content, attributes \\ %{}) do
    content
    |> cast(attributes, [:lang, :content])
    |> validate_required([:lang, :content])
  end

  @doc """
  Casts the embedded translation data into the given changeset and uses a given fields
  value as default label (in German!) when no translations are given
  """
  def cast_translation(cs, translation_field, opts \\ []) do
    cs =
      cs
      |> cast_embed(translation_field)

    from_field = opts[:infer_from]

    case {get_field(cs, translation_field), get_field(cs, from_field)} do
      {[], text} when is_binary(text) ->
        cs
        |> put_embed(translation_field, [%{content: text}])

      _existing_translations_or_no_text ->
        cs
    end
  end
end
