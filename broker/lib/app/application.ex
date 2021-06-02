defmodule App.Application do
  use Application

  def start(_type, _args) do

    children = [
      %{
        id: Broker,
        start: {Broker, :accept, [4040]}
      }
    ]

    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)
  end
end
