defmodule KinoCurl.ExCurlRequestAdapter do
  @moduledoc false

  @behaviour KinoCurl.RequestAdapter

  @impl true
  def request_to_source(%{"method" => "GET"} = parsed_request) do
    opts = parse_opts(parsed_request)

    if Enum.empty?(opts) do
      quote(do: ExCurl.get!(unquote(parsed_request["url"])))
    else
      quote(do: ExCurl.get!(unquote(parsed_request["url"]), unquote(opts)))
    end
  end

  @impl true
  def request_to_source(%{"method" => "POST"} = parsed_request) do
    opts = parse_opts(parsed_request)

    if Enum.empty?(opts) do
      quote(do: ExCurl.post!(unquote(parsed_request["url"])))
    else
      quote(do: ExCurl.post!(unquote(parsed_request["url"]), unquote(opts)))
    end
  end

  @impl true
  def request_to_source(%{"method" => "PATCH"} = parsed_request) do
    opts = parse_opts(parsed_request)

    if Enum.empty?(opts) do
      quote(do: ExCurl.patch!(unquote(parsed_request["url"])))
    else
      quote(do: ExCurl.patch!(unquote(parsed_request["url"]), unquote(opts)))
    end
  end

  @impl true
  def request_to_source(%{"method" => "PUT"} = parsed_request) do
    opts = parse_opts(parsed_request)

    if Enum.empty?(opts) do
      quote(do: ExCurl.put!(unquote(parsed_request["url"])))
    else
      quote(do: ExCurl.put!(unquote(parsed_request["url"]), unquote(opts)))
    end
  end

  @impl true
  def request_to_source(%{"method" => "DELETE"} = parsed_request) do
    opts = parse_opts(parsed_request)

    if Enum.empty?(opts) do
      quote(do: ExCurl.delete!(unquote(parsed_request["url"])))
    else
      quote(do: ExCurl.delete!(unquote(parsed_request["url"]), unquote(opts)))
    end
  end

  @impl true
  def request_to_source(parsed_request) do
    quote(
      do:
        ExCurl.request!(
          unquote(parsed_request["method"]),
          unquote(parsed_request["url"]),
          unquote(parse_opts(parsed_request))
        )
    )
  end

  defp parse_opts(%{"body" => nil, "header" => headers}) when is_map(headers),
    do: [headers: headers]

  defp parse_opts(%{"body" => body, "header" => headers}) when is_map(headers),
    do: [body: body, headers: headers]

  defp parse_opts(%{"body" => body, "header" => nil}), do: [body: body]
  defp parse_opts(_), do: []
end
