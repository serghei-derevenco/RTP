defmodule Aggregator do
  use GenServer

  def start_link(message) do
    GenServer.start(__MODULE__, message, name: __MODULE__)
  end

  def init(_arg) do
    initial_map = %{}
    {:ok, initial_map}
  end

  def handle_cast({:sentiment_score, {user, tweet, score}}, initial_map) do
    data = add_to_map("score", user, tweet, score, initial_map)
    {:noreply, %{}}
  end

  def handle_cast({:engagement_ratio, {user, tweet, ratio}}, initial_map) do
    data = add_to_map("ratio", user, tweet, ratio, initial_map)
    {:noreply, %{}}
  end

  defp add_to_map(topic, user, tweet, value, initial_map) do
    new_map = %{user: user, tweet: tweet, sentiment_score: value}
    send_map(topic, initial_map, new_map)
  end

  defp send_map(topic, initial_map, new_map) do
    map = Map.merge(initial_map, new_map)
    Broker.send_message(topic, map)
    # GenServer.cast(Sink, {:data, map})
  end
end
