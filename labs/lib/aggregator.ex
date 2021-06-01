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

  defp add_to_map(value_type, user, tweet, value, initial_map) do
    if value_type == "score" do
      new_map = %{user: user, tweet: tweet, sentiment_score: value}
      send_map(initial_map, new_map)
    else
      new_map = %{user: user, tweet: tweet, engagement_ratio: value}
      send_map(initial_map, new_map)
    end
  end

  defp send_map(initial_map, new_map) do
    map = Map.merge(initial_map, new_map)
    GenServer.cast(Broker, {:data, map})
    # GenServer.cast(Sink, {:data, map})
  end
end
