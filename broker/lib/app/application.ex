defmodule App.Application do
  use Application

  @port 2052

  def start(_type, _args) do

    children = [
      %{
        id: Client,
        start: {Client, :start, [@port]}
      },
      %{
        id: Server,
        start: {UdpServer, :start, [@port]}
      }
    ]

    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)
  end
end
