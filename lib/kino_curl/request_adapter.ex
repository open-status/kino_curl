defmodule KinoCurl.RequestAdapter do
  @moduledoc false

  @callback request_to_source(parsed_request :: map) :: source :: any
end
