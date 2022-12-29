defmodule KinoCurl.Cell do
  @moduledoc false

  use Kino.JS
  use Kino.JS.Live
  use Kino.SmartCell, name: "cURL Command"

  @default_command ~s(curl "https://hex.pm")

  defp request_adapter(), do: KinoCurl.ExCurlRequestAdapter

  @impl true
  def init(attrs, ctx) do
    ctx =
      assign(ctx,
        command: attrs["command"] || "",
        parsed_command: ~s({"method": "GET", "url": "https://hex.pm"})
      )

    broadcast_event(ctx, "parse_command", ctx.assigns.command)

    {:ok, ctx,
     editor: [attribute: "command", language: "shell", default_source: @default_command]}
  end

  @impl true
  def handle_connect(ctx) do
    broadcast_event(ctx, "parse_command", ctx.assigns.command)

    {:ok,
     %{
       parsed_command: ctx.assigns.parsed_command
     }, ctx}
  end

  @impl true
  def handle_event("parsed_command", command, ctx) do
    {:noreply, assign(ctx, parsed_command: command)}
  end

  @impl true
  def to_attrs(ctx) do
    %{
      "command" => ctx.assigns.command,
      "parsed_command" => ctx.assigns.parsed_command
    }
  end

  @impl true
  def to_source(attrs) do
    send(self(), {:parse, attrs["command"]})
    parsed_command = Jason.decode!(attrs["parsed_command"])

    if parsed_command["url"] == nil do
      raise "Invalid or missing URL."
    end

    quote do
      response = unquote(request_adapter().request_to_source(parsed_command))
    end
    |> Kino.SmartCell.quoted_to_string()
  rescue
    _ ->
      quote do
        raise KinoCurl.ParseError,
          message: """
          Failed to parse command.

          Must be a valid curl command using either `http` or `https`, for example:

          curl -X POST -d 'some_value=true' 'https://httpbin.org/post'

          Note: parse-curl.js (https://github.com/tj/parse-curl.js) is used to parse
          commands, so flag/argument support is currently dependent on parse-curl.js
          """
      end
      |> Kino.SmartCell.quoted_to_string()
  end

  @impl true
  def handle_info({:parse, command}, ctx) do
    broadcast_event(ctx, "parse_command", command)
    {:noreply, ctx}
  end

  asset "main.js" do
    """
    import parseCurl from "https://cdn.skypack.dev/parse-curl@0.2.6";

    export function init(ctx, payload) {
      ctx.handleEvent("parse_command", (command) => {
        ctx.pushEvent("parsed_command", JSON.stringify(parseCurl(command)));
      });

      ctx.handleSync(() => {
        // Synchronously invokes change listeners
        document.activeElement &&
          document.activeElement.dispatchEvent(new Event("change"));
      });
    }
    """
  end
end
