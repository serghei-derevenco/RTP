defmodule Worker do
  use GenServer

  def start_link(tweet) do
    GenServer.start_link(__MODULE__, tweet, name: __MODULE__)
  end

  def init(tweet) do
    {:ok, %{name: tweet}}
  end

  def handle_cast({:worker, tweet}, _state) do
    show_tweet(tweet)
    {:noreply, %{}}
  end

  defp parse_tweet(tweet) do
    chars = [".", ",", "!", "?", ":", ";"]
    map = Map.from_struct(tweet)
    {:ok, json} = JSON.decode(map.data)
    json["message"]["tweet"]["text"]
    |> String.replace(chars, "")
    |> String.split(" ", trim: true)
  end

  defp calculate_values(emotions) do
    emotions
    |> Enum.reduce(0, fn em, acc -> Emotions.get_value(em) + acc end)
    |> Kernel./(length(emotions))
  end

  defp show_tweet(tweet) do
    if String.contains?(tweet.data, "panic") do
      IO.inspect(%{"Panic message:" => tweet})
    else
      tweet
      |> parse_tweet()
      |> calculate_values()
      |> IO.inspect()
    end
  end
end
