defmodule Tmde.Helper.Markdown do
  @moduledoc """
  Helper functions to work with markdown files
  """

  @doc """
  Reads a markdown file and converts it to html.

  Options may contain:
   - `splitter`: A string that uses comment tags to convert only a section of the file. If
    you provide `splitter: "SPLITTER"`, it will use the content between the tags
    `<!-- SPLITTER_START -->`and `<!-- SPLITTER_END -->`.
   - for other options, refer to `Earmark.Options`
  """
  def file_to_html(path, opts \\ []) do
    {splitter, opts} = opts |> Keyword.pop(:splitter)

    if splitter do
      path
      |> File.read!()
      |> String.split("<!-- #{splitter}_START -->")
      |> Enum.at(1)
      |> String.split("<!-- #{splitter}_END -->")
      |> List.first()
      |> Earmark.as_html!(opts)
    else
      Earmark.from_file!(path, opts)
    end
  end
end
