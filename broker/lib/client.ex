defmodule Client do
  require Logger

  @host {127, 0, 0, 1}

  def init(port) do
    {:ok, socket} = :gen_udp.open(port, [:binary, active: true])
    Logger.info("Accepting connections on port #{port}")
    read(socket)
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
