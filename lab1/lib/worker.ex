defmodule Worker do
  use GenServer

  def start_link(tweet) do
    GenServer.start_link(__MODULE__, tweet, name: __MODULE__)
  end

  def init(tweet) do
    {:ok, tweet}
  end

  def handle_cast({:worker, tweet}, state) do
    # IO.inspect(%{"Tweet: " => tweet.data})
    get_tweet_text(tweet)
    {:noreply, state}
  end

  defp get_tweet_text(tweet) do
    # IEx.Info.info(tweet) |> IO.inspect()
    if String.contains?(tweet.data, "panic") do
      IO.inspect(%{"Panic message: " => tweet})
    else
      map = Map.from_struct(tweet)
      {:ok, json} = JSON.decode(map.data)
      text = json["message"]["tweet"]["text"]
      IO.inspect(%{"Tweet text: " => text})
    end
  end
end
