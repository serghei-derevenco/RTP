defmodule Broker do
  use GenServer

  @host {127, 0, 0, 1}

  def init(arg) do
    {:ok, arg}
  end

  def start_link(port) do
    {:ok, socket} = :gen_udp.open(port, [:binary, active: true])
    GenServer.start_link(__MODULE__, %{socket: socket}, name: __MODULE__)
  end

  def send_message(topic, message) do
    IO.puts("Sending data to server ->")
    GenServer.cast(__MODULE__, {:data, {topic, message}})
  end

  def handle_cast({:data, {topic, message}}, state) do
    data = encode_message(topic, message)
    :gen_tcp.send(state.socket, {@host, state.port}, data)
    {:noreply, state}
  end

  defp encode_message(topic, message) do
    Poison.encode!(%{
      topic: topic,
      data: message
    })
  end
end
