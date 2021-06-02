defmodule TcpServer do
  def listen(port) do
    :gen_tcp.listen(port, [:binary, active: false, reuseaddr: true])
  end

  def accept(socket) do
    :gen_tcp.accept(socket)
  end

  def send(socket, data) do
    :gen_tcp.send(socket, data)
  end

  def read(socket) do
    try do
      {:ok, data} = :gen_tcp.recv(socket, 0)
      data
    rescue
      _ -> :error
    end
  end
end
