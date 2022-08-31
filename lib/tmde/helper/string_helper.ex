defmodule Tmde.Helper.StringHelper do
  @moduledoc """
  Convenience helper methods for strings
  """

  def reject_empty(enum),
    do: Enum.reject(enum, &empty_string?/1)

  def empty_string?(nil), do: true
  def empty_string?(""), do: true
  def empty_string?(_), do: false
end
