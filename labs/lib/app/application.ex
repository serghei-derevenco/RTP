defmodule App.Application do
  use Application

  def start(_type, _args) do

    children = [

      %{
        id: Aggregator,
        start: {Aggregator, :start_link, [""]}
      },
      %{
        id: Sink,
        start: {Sink, :start_link, [""]}
      },
      %{
        id: EngagementWorker,
        start: {EngagementWorker, :start_link, [""]}
      },
      %{
        id: EngagementSupervisor,
        start: {EngagementSupervisor, :start_link, [""]}
      },
      %{
        id: Worker,
        start: {Worker, :start_link, [""]}
      },
      %{
        id: Supervisor,
        start: {WorkerSupervisor, :start_link, [""]}
      },
      %{
        id: Router,
        start: {Router, :start_link, [""]}
      },
      %{
        id: Connection1,
        start: {ServerConnection, :start_link, ["http://localhost:4000/tweets/1"]}
      },
      %{
        id: Connection2,
        start: {ServerConnection, :start_link, ["http://localhost:4000/tweets/2"]}
      }

    ]

    opts = [strategy: :one_for_one, name: App.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
