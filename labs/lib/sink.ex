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
    q = [item] ++ queue

    receive do
      after 200 ->
        GenServer.cast(__MODULE__, :batch_of_data)
    end

    {:noreply, q}
  end

  @impl true
  def handle_cast(:batch_of_data, queue) do
    IO.puts("-> Inserting batch of data to db...")
    IO.inspect(queue)
    insert_to_db(queue)

    {:noreply, []}
  end

  defp insert_to_db(list) do
    {:ok, conn} = Mongo.start_link(url: "mongodb://localhost:27017/rtp_db")
    Mongo.insert_many(conn, "tweets", list)
  end
end
