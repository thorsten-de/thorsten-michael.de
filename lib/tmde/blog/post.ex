defmodule Tmde.Blog.Post do
  @moduledoc """
  A blog post on my website
  """

  defstruct [:id, :author, :title, :body, :abstract, :tags, :date, :language]

  def build(filename, attrs, body) do
    IO.inspect([filename: filename, attrs: attrs, body: body], label: "Post.build/3")
    [year, month_day_id] = filename |> Path.rootname() |> Path.split() |> Enum.take(-2)
    [month, day, id] = String.split(month_day_id, "-", parts: 3)

    date = Date.from_iso8601!("#{year}-#{month}-#{day}")

    __MODULE__
    |> struct!([id: id, date: date, body: body] ++ Map.to_list(attrs))
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
end
