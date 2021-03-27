# Simple Sink Actor with a backpressure mechanism
defmodule Sink do
  use GenServer

  def start_link(message) do
    GenServer.start(__MODULE__, message, name: __MODULE__)
  end

  def init(_arg) do
    queue = []
    {:ok, queue}
  end

  @impl true
  def handle_cast({:data, item}, queue) do
    IO.puts("-> Inserting batch of data to db...")
    q = [item | queue]
    if Enum.count(q) >= 128 do
      GenServer.cast(__MODULE__, :batch_of_data)
    end

    {:noreply, q}
  end

  @impl true
  def handle_cast(:batch_of_data, queue) do
    spawn(fn ->
      Enum.each(queue, fn item ->
        insert_to_db(item, "tweets1")
      end)
    end)
    {:noreply, []}
  end

  defp insert_to_db(message, collection) do
    {:ok, pid} = Mongo.start_link(url: "mongodb://localhost:27017/rtp_db")
    Mongo.insert_one!(pid, collection, message)
  end
end
