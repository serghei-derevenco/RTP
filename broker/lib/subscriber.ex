defmodule Subscriber do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(_arg) do
    init_map = %{}
    {:ok, init_map}
  end

  def subscribe(topic, socket) do
    GenServer.cast(__MODULE__, {:subscribe, topic, socket})
  end

  def unsubscribe(socket) do
    GenServer.cast(__MODULE__, {:unsubscribe, socket})
  end

  def handle_cast({:subscribe, topic, socket}, init_map) do
    subscribers = get_subscribers(init_map, topic)
    new_map = Map.put(init_map, topic, [socket | subscribers])
    {:noreply, new_map}
  end

  def handle_cast({:unsubscribe, socket}, init_map) do
    new_map = %{}
    for {topic, subscribers} <- init_map do
      Map.put(new_map, topic, Enum.filter(subscribers, fn s -> s != socket end))
    end
    {:noreply, new_map}
  end

  def handle_call({:all_subscribers, topic}, init_map) do
    {:reply, get_subscribers(init_map, topic), init_map}
  end

  def get_subscribers(map, key) do
    cond do
      subscribers = Map.get(map, key) -> subscribers
      true -> []
    end
  end
 end
