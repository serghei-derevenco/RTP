defmodule Worker do
  use GenServer

  def start_link(tweet) do
    GenServer.start_link(__MODULE__, tweet, name: __MODULE__)
  end

  def init(tweet) do
    {:ok, tweet}
  end

  def handle_cast({:worker, tweet}, _state) do
    show_score(tweet)
    {:noreply, %{}}
  end

  defp parse_tweet(tweet) do
    map = Map.from_struct(tweet)
    {:ok, json} = JSON.decode(map.data)
    json
  end

  defp get_emotions(tweet) do
    chars = [".", ",", "!", "?", ":", ";"]
    tweet["message"]["tweet"]["text"]
    |> String.replace(chars, "")
    |> String.split(" ", trim: true)
  end

  defp calculate_values(emotions) do
    emotions
    |> Enum.reduce(0, fn em, acc -> Emotions.get_value(em) + acc end)
    |> Kernel./(length(emotions))
  end

  defp show_score(tweet) do
    if String.contains?(tweet.data, "panic") do
      IO.inspect(%{"Panic message:" => tweet})
    else
      parsed_tweet = parse_tweet(tweet)
      emotions = get_emotions(parsed_tweet)
      values = calculate_values(emotions)

      user = parsed_tweet["message"]["tweet"]["user"]["screen_name"]

      dict = %{user: user, tweet: parsed_tweet, sentiment_score: values}

      GenServer.cast(Sink, {:data, dict})
    end
  end
end
