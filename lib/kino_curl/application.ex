defmodule KinoCurl.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    Kino.SmartCell.register(KinoCurl.Cell)

    children = []
    opts = [strategy: :one_for_one, name: KinoCurl.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
