defmodule Tmde.Helper.MarkdownTest do
  use ExUnit.Case
  alias Tmde.Helper.Markdown

  setup_all do
    %{
      html_full:
        "<h1>\nH1</h1>\n<p>\ncontent before</p>\n<!-- TEST_START -->\n<h2>\nH2</h2>\n<p>\ninner content</p>\n<!-- TEST_END -->\n<p>\ncontent after</p>\n",
      html_splitted: "<h2>\nH2</h2>\n<p>\ninner content</p>\n"
    }
  end

  @markdown_file "test/support/markdown/input.md"
  @bad_splitter_file "test/support/markdown/bad_splitter.md"

  describe "file_to_html!/2" do
    test "reads and converts a whole markdown file", %{html_full: output} do
      result = Markdown.file_to_html!(@markdown_file)
      assert result == output
    end

    test "reads and converts content between comments when splitter is provided", %{
      html_splitted: output
    } do
      result = Markdown.file_to_html!(@markdown_file, splitter: "TEST")

      assert result == output
    end

    test "fails if file is not found" do
      assert catch_error(Markdown.file_to_html!("BAD_FILENAME.md"))
    end

    test "fails if splitter is given, but start comment not found in file" do
      assert_raise ArgumentError, ~r/2_START/, fn ->
        Markdown.file_to_html!(@bad_splitter_file, splitter: "2")
      end
    end

    test "fails if splitter is given, but end comment not found in file" do
      assert_raise ArgumentError, ~r/1_END/, fn ->
        Markdown.file_to_html!(@bad_splitter_file, splitter: "1")
      end
    end
  end

  describe "content_to_html!/2" do
    test "given a keyword list of files by locale, returns a keyword list of content by locale",
         %{
           html_full: html
         } do
      result =
        Markdown.content_to_html!(
          de: @markdown_file,
          en: @bad_splitter_file
        )

      assert %{
               "de" =>  %{path: @markdown_file, html: ^html},
               "en" => %{path: @bad_splitter_file}
       } = result

      assert result["de"].html != result["en"].html
    end

    test "delegates splitter and options correctly", %{html_splitted: html} do
      assert %{"de"=> %{html: ^html}} =
               Markdown.content_to_html!([de: @markdown_file], splitter: "TEST")
    end
  end
end
