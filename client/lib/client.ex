defmodule Client do
  require Logger

  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(port, [:binary, active: false, reuseaddr: true])
    Logger.info("Accepting connections on port #{port}")

    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    serve(client)

    loop_acceptor(socket)
  end

  def serve(:error, client) do
    Logger.info("Error occured!")
  end

  def serve(socket) do
    Logger.info("Data from other side:")
    socket
    |> read_data()

    serve(socket)
  end

  def read_data(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    if Map.has_key?(data["data"], :sentiment_score) do
      GenServer.cast(__MODULE__, {:tweet_with_score, data})
    else
      GenServer.cast(__MODULE__, {:tweet_with_ratio, data})
    end
  end

  def send_message(message, socket) do
    :gen_tcp.send(socket, message)
  end

  def subscribe(topic) do
    GenServer.cast(__MODULE__, {:subscribe, %{subscribe: true, topic: topic}})
  end

  def unsubscribe(topic) do
    GenServer.cast(__MODULE__, {:subscribe, %{subscribe: false, topic: topic}})
  end

  def handle_cast({:subscribe, data}, state) do
    send_message(data, state.socket)
  end

  def handle_cast({:tweet_with_score, map}, state) do
    IO.puts("Initial tweet -----")
    IO.inspect(map["tweet"])
    IO.puts("Sentimnet score:")
    IO.inspect(map["sentiment_score"])
  end

  def handle_cast({:tweet_with_ratio, map}, state) do
    IO.puts("Initial tweet -----")
    IO.inspect(map["tweet"])
    IO.puts("Engagement ratio:")
    IO.inspect(map["engagement_ratio"])
  end
end
