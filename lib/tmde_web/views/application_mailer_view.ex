defmodule TmdeWeb.ApplicationMailerView do
  use TmdeWeb, :view

  def to_style(attribs) do
    attribs
    |> Enum.reject(fn {_key, value} -> is_nil(value) end)
    |> Enum.map(fn {key, value} -> "#{key}:#{value};" end)
    |> Enum.join("")
  end
end
