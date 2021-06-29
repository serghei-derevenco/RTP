defmodule TcpServer do
  require Logger

  def listen(port) do
    {:ok, socket} = :gen_tcp.listen(port, [:binary, active: false, reuseaddr: true])
    Logger.info("Server is accepting connections on port #{port}")
    accept(socket)
  end

  def accept(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    pid = spawn_link(__MODULE__, :read, [client])
    :gen_tcp.controlling_process(client, pid)
    accept(socket)
  end

  def send(socket, data) do
    :gen_tcp.send(socket, data)
  end

  def read(socket) do
    try do
      {:ok, data} = :gen_tcp.recv(socket, 0)
      parse_message(socket, data)
    rescue
      _ -> :error
    end
  end

  def parse_message(socket, data) do
    {topic, message} = decode_message(data)
    subscribers = GenServer.handle_call(Subscriber, {:all_subscribers, topic})
    Enum.each(subscribers, fn s -> send(s, message) end)
  end

  defp decode_message(data) do
    {:ok, message} = Poison.decode(data)
    {message["topic"], message["data"]}
  end
end
