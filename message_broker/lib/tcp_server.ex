defmodule TcpServer do
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

  def serve(data, socket) do
    Logger.info("Data from client:")
    IO.inspect(data)

    serve(socket)
  end

  def serve(socket) do
    data = try do
      {:ok, data} = :gen_tcp.recv(socket, 0)
      data
    rescue
      _ -> :error
    end
    serve(data, socket)
  end
end
