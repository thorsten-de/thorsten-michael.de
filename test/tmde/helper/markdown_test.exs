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

  describe "Earmark.from_file!/2" do
    test "due to a bug, it fails when not reading .eex files with Earmark.from_file!" do
      assert_raise ArgumentError, ~r/:sys_interface/, fn ->
        Earmark.from_file!(@markdown_file)
      end
    end
  end

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
      assert_raise File.Error, fn ->
        Markdown.file_to_html!("bad_filename.md")
      end
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
end
