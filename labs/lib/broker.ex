defmodule Broker do
  use GenServer

  def init(arg) do
    {:ok, arg}
  end

  def start_link(host, port) do
    {:ok, socket} = :gen_tcp.connect(host, port, [:binary, active: false])
    GenServer.start_link(__MODULE__, %{socket: socket}, name: __MODULE__)
  end

  def sendMap(topic, map) do
    IO.puts("Sending data to client ->")
    GenServer.cast(__MODULE__, {:data, %{type: "data", topic: topic, data: map}})
  end

  def handle_cast({:data, map}, state) do
    :gen_tcp.send(state.socket, map)
    {:noreply, state}
  end
end
