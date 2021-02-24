defmodule Connection do

  def start_link(url) do
    func = spawn(__MODULE__, :get_tweet, [])
    {:ok, pid} = EventsourceEx.new(url, stream_to: func)

    Process.monitor(pid)
    
    receive do
      error ->
        {:ok, pid} = EventsourceEx.new(url, stream_to: func)
    end

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
