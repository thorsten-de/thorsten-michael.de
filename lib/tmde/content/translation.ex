defmodule Tmde.Content.Translation do
  @moduledoc """
  An embed that represents content in a specific language
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias __MODULE__

  @types [text: "Text", markdown: "Markdown", html: "HTML"]

  embedded_schema do
    field :lang, :string, default: "de"
    field :type, Ecto.Enum, values: Keyword.keys(@types), default: :text
    field :content, :string
  end

  def all_content_types, do: @types

  def changeset(content, attributes \\ %{}) do
    content
    |> cast(attributes, [:lang, :type, :content])
    |> validate_required([:lang, :type, :content])
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

  def remove_translation_changeset(data, translation_field, id) do
    translations =
      data
      |> Map.get(translation_field, [])
      |> Enum.reject(&(&1.id == id))

    data
    |> change()
    |> put_embed(translation_field, translations)
  end

  def translations(translations \\ []) do
    translations
    |> Enum.map(fn
      {lang, type, text} -> %{lang: to_string(lang), content: text, type: type}
      {lang, text} -> %{lang: to_string(lang), content: text, type: :html}
      text when is_binary(text) -> %{content: text, type: :html}
    end)
  end

  @doc """
  Finds the translation and returns the content, otherwise returns an empty string.
  """
  def translate(translations, lang \\ "de")

  def translate(translations, lang) when is_list(translations) do
    translations
    |> Enum.find(fn
      %{lang: item_lang} -> lang == item_lang
      _ -> false
    end)
    |> case do
      %__MODULE__{} = m -> m
      _ -> List.first(translations, nil)
    end
  end

  def translate(_translations, _lang), do: nil

  defimpl Phoenix.HTML.Safe, for: __MODULE__ do
    def to_iodata(%Translation{type: :html, content: content}), do: content

    def to_iodata(%Translation{type: :text, content: content}) do
      {:safe, text} = Phoenix.HTML.Format.text_to_html(content)
      text
    end

    def to_iodata(%Translation{type: :markdown, content: content}), do: Earmark.as_html!(content)
  end

  defmacro translation_field(field) do
    quote bind_quoted: binding() do
      Ecto.Schema.embeds_many(field, Translation, on_replace: :delete)
    end
  end
end
