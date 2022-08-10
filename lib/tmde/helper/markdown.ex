defmodule Tmde.Helper.Markdown do
  @moduledoc """
  Helper functions to work with markdown files
  """

  @doc """
  Reads a markdown file and converts it to html.

  Options may contain:
   - `splitter`: A string that uses comment tags to convert only a section of the file. If
    you provide `splitter: "SPLIT"`, it will use the content between the tags
    `<!-- SPLIT_START -->`and `<!-- SPLIT_END -->`. Raises an ´ArgumentError´ if comments
    not found.
   - for other options, refer to `Earmark.Options`
  """
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
      |> File.read!()
      |> Earmark.as_html!(opts)

      # TODO as Earmark.from_file!(path, opts) currently won't work properly
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
