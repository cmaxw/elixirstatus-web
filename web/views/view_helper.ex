defmodule ViewHelper do
  use PhoenixHtmlSanitizer, :markdown_html

  alias ElixirStatus.User
  alias ElixirStatus.Date

  @promo_templates ["promo_credo.html", "promo_elixirweekly.html"]
  @twitter_screen_name Application.get_env(:elixir_status, :twitter_screen_name)

  def promo_template_name do
    @promo_templates |> Enum.random()
  end

  def avatar_path(%User{user_name: user_name}), do: avatar_path(user_name)

  def avatar_path(user_name) when is_binary(user_name) do
    "https://github.com/#{user_name}.png?size=128"
  end

  def class_with_error(form, field, base_class) do
    if error_on_field?(form, field) do
      "#{base_class} error"
    else
      base_class
    end
  end

  def error_on_field?(form, field) do
    form.errors
    |> Enum.map(fn {attr, _message} -> attr end)
    |> Enum.member?(field)
  end

  # why does `import ElixirStatus.Auth` not work here?
  def current_user(conn), do: ElixirStatus.Auth.current_user(conn)
  def logged_in?(conn), do: ElixirStatus.Auth.logged_in?(conn)
  def admin?(conn), do: ElixirStatus.Auth.admin?(conn)

  @doc "Returns a date formatted for humans."
  def human_readable_date(date, use_abbrevs? \\ true)

  def human_readable_date(date, use_abbrevs?) when is_binary(date) do
    NaiveDateTime.from_iso8601!(date)
    |> human_readable_date(use_abbrevs?)
  end

  def human_readable_date(date, use_abbrevs?) do
    if use_abbrevs? && this_year?(date) do
      cond do
        today?(date) ->
          "Today"

        yesterday?(date) ->
          "Yesterday"

        true ->
          date |> Date.strftime("%e %b")
      end
    else
      date |> Date.strftime("%e %b %Y")
    end
  end

  @doc "Returns a date formatted for RSS clients."
  def xml_readable_date(date) do
    Date.strftime(date, "%e %b %Y %T %z")
  end

  defp this_year?(date), do: date.year == NaiveDateTime.utc_now().year

  defp today?(date) do
    now = NaiveDateTime.utc_now()
    same_day?(date, now)
  end

  def yesterday?(date) do
    now = NaiveDateTime.utc_now()
    yesterday = ElixirStatus.Date.days_ago(now, 1)

    same_day?(date, yesterday)
  end

  defp same_day?(date1, date2) do
    date1.day == date2.day && date1.month == date2.month && date1.year == date2.year
  end

  def sanitized_markdown(nil), do: ""

  def sanitized_markdown(text) do
    text
    |> Earmark.to_html()
    |> sanitize
  end

  def strip_tags(text) do
    sanitize(text, :strip_tags)
  end

  def twitter_screen_name, do: @twitter_screen_name
end
