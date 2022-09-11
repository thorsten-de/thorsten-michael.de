defmodule TmdeWeb.DateFormatter do
  import TmdeWeb.Gettext

  @default_format "{0D}.{0M}.{YYYY}"
  @default_locale "de"

  def date(date, opts \\ []) do
    format = opts[:format] || @default_format
    locale = opts[:locale] || @default_locale

    format_date(date, format, locale)
  end

  defp format_date(nil, _format, _locale), do: nil

  defp format_date(date, format, _locale),
    do: date |> Timex.format!(format)

  def date_interval(interval, opts \\ []) when is_map(interval) do
    case interval do
      %{from: nil, until: nil} ->
        ""

      %{from: nil, until: until} ->
        gettext("until %{date}", date: date(until, opts))

      %{from: from, until: nil} ->
        gettext("%{date} - today", date: date(from, opts))

      %{from: from, until: until} ->
        gettext("%{from} - %{until}",
          from: date(from, opts),
          until: date(until, opts)
        )
    end
  end

  def humanize_duration(%{from: from, until: until}, opts \\ []) do
    until = until || Timex.today()
    _locale = opts[:locale] || @default_locale

    Timex.diff(until, from, :duration)
    |> IO.inspect()
    |> Timex.format_duration(Timex.Format.Duration.Formatters.Humanized)
  end
end
