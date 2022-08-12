defmodule Tmde.Helper.Markdown do
  @moduledoc """
  Helper functions to work with markdown files
  """
  @type filename :: binary()
  @type html_content :: binary()

  @spec content_to_html!(keyword(filename), keyword) ::
          keyword(%{path: filename, html: html_content})
  @doc """
  given a keyword list of locales and markdown file paths, it converts the markdown files
  to html and returns a keyword list of %{path: _, html: _} maps for each local file.
  """
  def content_to_html!(contents, opts \\ []) do
    for {lang, path} <- contents do
      {lang,
       %{
         path: path,
         html: file_to_html!(path, opts)
       }}
    end
  end

  @doc """
  Reads a markdown file and converts it to html.

  Options may contain:
   - `splitter`: A string that uses comment tags to convert only a section of the file. If
    you provide `splitter: "SPLIT"`, it will use the content between the tags
    `<!-- SPLIT_START -->`and `<!-- SPLIT_END -->`. Raises an ´ArgumentError´ if comments
    not found.
   - for other options, refer to `Earmark.Options`
  """
  @spec file_to_html!(filename, keyword) :: html_content
  def file_to_html!(path, opts \\ []) do
    {splitter, opts} = opts |> Keyword.pop(:splitter)

    if splitter do
      path
      |> File.read!()
      |> drop_before(splitter)
      |> drop_after(splitter)
      |> Earmark.as_html!(opts)
    else
      path
      |> Earmark.from_file!(opts)
    end
  end

  defp drop_before(content, splitter) do
    comment = "<!-- #{splitter}_START -->"

    case String.split(content, comment) do
      [_before, content | _rest] -> content
      _ -> raise ArgumentError, "Splitter '#{comment}' not found in file"
    end
  end

  defp drop_after(content, splitter) do
    comment = "<!-- #{splitter}_END -->"

    case String.split(content, comment) do
      [content, _after | _rest] -> content
      _ -> raise ArgumentError, "Splitter '#{comment}' not found in file"
    end
  end
end
