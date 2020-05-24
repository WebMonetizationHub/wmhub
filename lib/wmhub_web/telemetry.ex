defmodule WmhubWeb.Telemetry do
  use Supervisor
  import Telemetry.Metrics

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    children = [
      {:telemetry_poller, measurements: periodic_measurements(), period: 10_000}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def metrics do
    [
      # Phoenix Metrics
      summary("phoenix.endpoint.stop.duration",
        unit: {:native, :millisecond}
      ),
      summary("phoenix.router_dispatch.stop.duration",
        tags: [:route],
        unit: {:native, :millisecond}
      ),

      summary("wmhub.repo.query.total_time", unit: {:native, :millisecond}),
      summary("wmhub.repo.query.decode_time", unit: {:native, :millisecond}),
      summary("wmhub.repo.query.query_time", unit: {:native, :millisecond}),
      summary("wmhub.repo.query.queue_time", unit: {:native, :millisecond}),
      summary("wmhub.repo.query.idle_time", unit: {:native, :millisecond}),
      counter("wmhub.payment.received.count", tags: [:payment_pointer]),
      counter("wmhub.payment.received.count", tags: [:request_id]),

      summary("vm.memory.total", unit: {:byte, :kilobyte}),
      summary("vm.total_run_queue_lengths.total"),
      summary("vm.total_run_queue_lengths.cpu"),
      summary("vm.total_run_queue_lengths.io")
    ]
  end

  defp periodic_measurements do
    []
  end
end
