defmodule EngagementWorker do
  use GenServer

  def start_link(tweet) do
    GenServer.start_link(__MODULE__, tweet, name: __MODULE__)
  end

  def init(tweet) do
    {:ok, %{name: tweet}}
  end

  def handle_cast({:engagement_worker, tweet}, _state) do
    show_ratio(tweet)
    {:noreply, %{}}
  end

  defp parse_tweet(tweet) do
    map = Map.from_struct(tweet)
    {:ok, json} = JSON.decode(map.data)
    json
  end

  defp calculate_ratio(favourites, retweets, followers) do
    if followers != 0 do
      ratio = (favourites + retweets) / followers
      IO.inspect("Ratio: " <> Float.to_string(ratio))
    else
      ratio = favourites + retweets
      IO.inspect("Ratio: " <> Integer.to_string(ratio))
    end
  end

  defp calculate_values(tweet) do
    retweeted_status = tweet["message"]["tweet"]["retweeted_status"]
    if retweeted_status != nil do
      favourites = retweeted_status["favorite_count"]
      retweets = retweeted_status["retweet_count"]
      followers = retweeted_status["user"]["followers_count"]

      calculate_ratio(favourites, retweets, followers)
    else
      IO.inspect(%{"retweeted_status" => retweeted_status})
    end
  end

  defp show_ratio(tweet) do
    if String.contains?(tweet.data, "panic") do
      IO.inspect(%{"Panic message:" => tweet})
    else
      tweet
      |> parse_tweet()
      |> calculate_values()
    end
  end
end
