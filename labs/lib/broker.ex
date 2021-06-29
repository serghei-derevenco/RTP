defmodule Broker do
  use GenServer

  def init(arg) do
    {:ok, arg}
  end

  def start_link(host, port) do
    {:ok, socket} = :gen_tcp.connect(host, port, [:binary, active: false])
    GenServer.start_link(__MODULE__, %{socket: socket}, name: __MODULE__)
  end

  def send_message(topic, message) do
    IO.puts("Sending data to server ->")
    GenServer.cast(__MODULE__, {:data, {topic, message}})
  end

  def handle_cast({:data, {topic, message}}, state) do
    data = encode_message(topic, message)
    :gen_tcp.send(state.socket, data)
    {:noreply, state}
  end

  defp encode_message(topic, message) do
    Poison.encode!(%{
      topic: topic,
      data: message
    })
  end
end
