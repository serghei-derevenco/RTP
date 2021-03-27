defmodule EngagementSupervisor do
  use DynamicSupervisor

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_worker(message) do
    spec = {EngagementWorker, {message}}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  def stop_worker(worker_pid) do
    DynamicSupervisor.terminate_child(__MODULE__, worker_pid)
  end

  def count_workers() do
    DynamicSupervisor.count_children(__MODULE__)
  end
end
