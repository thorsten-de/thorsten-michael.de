defmodule Tmde.Blog.Post do
  @moduledoc """
  A blog post on my website
  """

  defstruct [
    :id,
    :author,
    :title,
    :body,
    :abstract,
    :tags,
    :date,
    :language,
    :estimated_reading_time
  ]

  def build(filename, attrs, body) do
    [year, month_day_id] = filename |> Path.rootname() |> Path.split() |> Enum.take(-2)
    [month, day, id] = String.split(month_day_id, "-", parts: 3)

    date = Date.from_iso8601!("#{year}-#{month}-#{day}")

    # |> Float.to_string(decimals: 0)
    estimated_reading_time =
      attrs[:estimated_reading_time] ||
        Float.ceil(count_words(body) / 180.0) |> trunc()

    author = attrs[:author] || "Thorsten Deinert"

    __MODULE__
    |> struct!(
      [
        id: id,
        date: date,
        body: body,
        estimated_reading_time: estimated_reading_time,
        author: author
      ] ++
        Map.to_list(attrs)
    )
  end

  def where(obj, defs \\ []) do
    defs
    |> Enum.all?(fn {key, value} -> where(obj, key, value) end)
  end

  def where(post, key, value) do
    case Map.get(post, key) do
      list when is_list(list) -> value in list
      item -> value == item
    end
  end

  def count_words(phrase) do
    phrase
    |> String.split()
    |> Enum.count()
  end
end
