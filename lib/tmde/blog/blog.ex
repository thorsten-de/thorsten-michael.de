defmodule Tmde.Blog do
  @moduledoc """
  Blog context
  """

  alias __MODULE__.Post

  use NimblePublisher,
    build: Post,
    from: "content/blog/**/*.md",
    as: :posts,
    highlighters: [:makeup_elixir, :makeup_erlang]

  defmodule NotFoundError, do: defexception([:message, plug_status: 404])

  @posts Enum.sort_by(@posts, & &1.date, {:desc, Date})

  @tags @posts |> Enum.flat_map(& &1.tags) |> Enum.uniq() |> Enum.sort()

  def all_posts, do: @posts

  def recent_posts(count \\ 5, filter \\ []) do
    all_posts()
    |> Enum.filter(&Post.where(&1, filter))
    |> Enum.take(count)
  end

  def all_tags, do: @tags

  def get_post_by_id!(id) do
    all_posts()
    |> Enum.find(&(&1.id == id)) ||
      raise NotFoundError, "no post found with id=#{id}"
  end
end
