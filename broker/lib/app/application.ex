defmodule App.Application do
  use Application

  @port 2052

  def start(_type, _args) do

    children = [
      {:ok, _pid} = Supervisor.start_link([{UDPServer, @port}], strategy: :one_for_one)
      {:ok, _pid} = Supervisor.start_link([{UDPServer, @port}], strategy: :one_for_one)
    ]

    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)
  end
end
