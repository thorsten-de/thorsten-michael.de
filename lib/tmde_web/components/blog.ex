defmodule TmdeWeb.Components.Blog do
  @moduledoc """
  Components related to blog posts
  """
  use TmdeWeb, :component
  use Bulma
  import Bulma.Tags

  alias Tmde.Blog
  alias Blog.Post

  @spec post_meta(map) :: Phoenix.LiveView.Rendered.t()
  @doc "Show post metadata"
  attr :post, Post, required: true

  def post_meta(assigns) do
    ~H"""
    <.level class="post__meta">
      <:left class="post__meta-date">
        <.label icon="calendar" label={date(@post.date, format: "{0D}. {Mfull} {YYYY}")} />
      </:left>
      <:left class="post__meta-estimated_read">
        <.label
          icon="clock"
          label={ngettext("less than one minute", "%{count} minutes", @post.estimated_reading_time)}
        />
      </:left>
      <:right class="post__meta-tags">
        <.label icon="tags" icon_set="solid" label={Enum.join(@post.tags, ", ")} />
      </:right>
    </.level>
    """
  end

  @spec post(map) :: Phoenix.LiveView.Rendered.t()
  attr :post, Post, required: true

  def post(assigns) do
    ~H"""
    <.title label={@post.title} />
    <.post_image image={@post.image} />

    <.post_meta post={@post} />
    <.content class="post">
      <.abstract text={@post.abstract} />
      <%= raw(@post.body) %>
    </.content>
    <.tag_list post={@post} />
    """
  end

  attr :post, Post, required: true

  def tag_list(assigns) do
    ~H"""
    <.tags>
      <Tags.tag
        :for={tag <- @post.tags}
        color={["link", "light"]}
        icon="tags"
        icon_set="solid"
        label={tag}
      />
    </.tags>
    """
  end

  def abstract(assigns) do
    ~H"""
    <p class="is-family-secondary">
        <%= @text %>
    </p>
    """
  end

  def post_list(assigns) do
    ~H"""
    <.card :for={post <- @posts} class="m-3">
      <.post_meta post={post} />
      <.title size="4" label={post.title} />
      <.abstract text={post.abstract} />
      <.link class="mt-5 button is-link" href={Routes.blog_path(TmdeWeb.Endpoint, :show, post)}>
        <%= gettext("Read all") %>
      </.link>
    </.card>
    """
  end

  def post_image(assigns = %{image: nil}), do:
    ~H"""
    """

  def post_image(assigns) do
    ~H"""
    <picture class="image is-16-by9">
      <source type="image/webp" srcset={"/images/#{@image}_2x.webp"}>
      <img src={"/images/#{@image}_1920.jpg"} />
    </picture>
    """
  end

end
