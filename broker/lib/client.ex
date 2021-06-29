defmodule Client do
  require Logger

  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(port, [:binary, active: false, reuseaddr: true])
    Logger.info("Accepting connections on port #{port}")
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = TcpServer.accept(socket)
    pid = spawn_link(__MODULE__, :read, [client])
    :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket)
  end

  def read(socket) do
    try do
      {:ok, data} = :gen_tcp.recv(socket, 0)
      parse_message(socket, data)
    rescue
      _ -> Subscriber.unsubscribe(socket)
    end

    read(socket)
  end

  def parse_message(socket, message) do
    check_message("score", message, socket)
    check_message("ratio", message, socket)
  end

  def check_message(topic, message, socket) do
    if Map.get(message, topic) != nil do
      IO.inspect(message)
    else
      Subscriber.subscribe(topic, socket)
    end
  end
end
