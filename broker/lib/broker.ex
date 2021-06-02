defmodule Broker do
  require Logger

  def accept(port) do
    {:ok, socket} = TcpServer.listen(port)
    Logger.info("Broker is accepting connections on port #{port}")
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = TcpServer.accept(socket)
    pid = spawn_link(__MODULE__, :read, [client])
    :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket)
  end

  def read(:error, socket) do
    Logger.info("Error occured!")
  end

  def read(data, socket) do
    IO.puts("Getting data from client...")
    IO.inspect(data)
    Handler.handle(data, socket)
    read(socket)
  end

  def read(socket) do
    data = TcpServer.read(socket)
    read(data, socket)
  end
end
