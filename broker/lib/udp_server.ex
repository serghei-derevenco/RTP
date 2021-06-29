defmodule UdpServer do
  require Logger

  @host {127, 0, 0, 1}

  def init(port) do
    {:ok, socket} = :gen_udp.open(port, [:binary, active: true])
    Logger.info("Server is accepting connections on port #{port}")
    read(socket)
  end

  def send(socket, port, data) do
    :gen_tcp.send(socket, {@host, port}, data)
  end

  def read(socket) do
    try do
      {:ok, {socket, port, data}} = :gen_udp.recv(socket, 0)
      if data == "quit" do
        :gen_udp.close(socket)
      else
        parse_message(socket, port, data)
      end
    rescue
      _ -> :error
    end

    read(socket)
  end

  def parse_message(socket, data) do
    {topic, message} = decode_message(data)
    subscribers = GenServer.handle_call(Subscriber, {:all_subscribers, topic})
    Enum.each(subscribers, fn s -> send(s, port, message) end)
  end

  defp decode_message(data) do
    {:ok, message} = Poison.decode(data)
    {message["topic"], message["data"]}
  end
end
