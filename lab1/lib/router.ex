defmodule Router do
  use GenServer

  def start_link(message) do
    GenServer.start_link(__MODULE__, message, name: __MODULE__)
  end

  def init(message) do
    {:ok, message}
  end

  def handle_cast({:router, message}, state) do
    WorkerSupervisor.start_worker(message)
    GenServer.cast(Worker, {:worker, message})
    {:noreply, state}
  end
end
