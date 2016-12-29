# Basically the same as HTTP.Response,
# because the rest of a response is generic headers and fields
defmodule HTTP.StatusLine do
  @moduledoc """
  Working with HTTP response codes

  Defined status-lines are from https://tools.ietf.org/html/rfc7231#section-6.1
  """
  @external_resource "./rfc7231.status_codes"

  path = Path.expand(@external_resource, Path.dirname(__ENV__.file))
  {:ok, file} = File.read(path)
  file = String.strip(file)
  [header | lines] = String.split(file, "\n")
  statuses = Enum.map(lines, fn
    (status_string) ->
      {code, " " <> reason_phrase} = Integer.parse(status_string)
      {code, reason_phrase}
  end)

  @doc """
  Expand a status code into the correct status line

  Variable naming from https://www.w3.org/Protocols/rfc2616/rfc2616-sec6.html
  """
  for status_string <- lines do
    {code, " " <> reason_phrase} = Integer.parse(status_string)
    def status_line(unquote(code)) do
      "HTTP/1.1 " <> unquote(status_string) <> "\r\n"
    end
  end

  @doc """
  List of all statuses as tuples of `{code, reason}`
  """
  def statuses do
    unquote(statuses)
  end

end
