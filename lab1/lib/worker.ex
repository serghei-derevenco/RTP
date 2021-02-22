defmodule Worker do
  use GenServer

  def start_link(tweet) do
    GenServer.start_link(__MODULE__, tweet, name: __MODULE__)
  end

  def init(tweet) do
    {:ok, tweet}
  end

  def handle_cast({:worker, tweet}, state) do
    IO.inspect(%{"Tweet: " => tweet})
    {:noreply, state}
  end
end
