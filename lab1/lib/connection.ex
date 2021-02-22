defmodule Connection do

  def start_link(url) do
    {:ok, _pid} = EventsourceEx.new(url, stream_to: self())
    get_tweet()
  end

  def get_tweet() do
    receive do
      tweet -> GenServer.cast(Router, {:router, tweet})
    end

    get_tweet()
  end

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :permanent,
    }
  end
end
