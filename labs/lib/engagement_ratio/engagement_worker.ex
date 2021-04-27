defmodule EngagementWorker do
  use GenServer

  def start_link(tweet) do
    GenServer.start_link(__MODULE__, tweet, name: __MODULE__)
  end

  def init(tweet) do
    {:ok, tweet}
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
      (favourites + retweets) / followers
    else
      favourites + retweets
    end
  end

  defp calculate_values(tweet) do
    retweeted_status = tweet["message"]["tweet"]["retweeted_status"]
    if retweeted_status != nil do
      favourites = retweeted_status["favorite_count"]
      retweets = retweeted_status["retweet_count"]
      followers = retweeted_status["user"]["followers_count"]

      ratio = calculate_ratio(favourites, retweets, followers)

      user = tweet["message"]["tweet"]["user"]["screen_name"]

      GenServer.cast(Aggregator, {:engagement_ratio, {user, tweet, ratio}})
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
