defmodule Handler do
  require Logger

  def send_data(socket, data) do
    try do
      TcpServer.send(socket, data)
    rescue
      _ ->
        Logger.info("Error occured while sending data to client.")
    end
  end

  def handle(data, socket) do
    if data["subscribe"] == true do
      Logger.info("Sending data to client...")
      send_data(socket, data["data"])
    else
      Logger.info("Unsubscribing client from topic #{data['data']}.")
    end
  end
end
