defmodule WmhubWeb.MonetizationChannel do
  use WmhubWeb, :channel

  alias Wmhub.Pointers
  alias Wmhub.Payments
  require Logger

  def monetization_assigns(socket, project_id) do
    socket
    |> assign(:project_id, project_id)
  end

  def join("monetization:" <> project_id, _, socket) do
    send(self(), :after_join)
    {:ok, %{pointers: Pointers.list(project_id)}, monetization_assigns(socket, project_id)}
  end
  
  def handle_in("monetization_pending", _payload, socket) do
    {:noreply, socket}
  end

  def handle_in("monetization_started", _payload, socket) do
    {:noreply, socket}
  end

  def handle_in("monetization_stopped", _payload, socket) do
    {:noreply, socket}
  end

  def handle_in("monetization_progress", %{"details" => details}, socket) do
    %{
      "amount" => amount,
      "assetCode" => asset_code,
      "assetScale" => asset_scale,
      "paymentPointer" => payment_pointer,
      "requestId" => request_id
    } = details
    {amount, _rest} = Integer.parse(amount)
    payment = %{
      amount: amount,
      asset_code: asset_code,
      asset_scale: asset_scale,
      payment_pointer: payment_pointer,
      request_id: request_id,
      project_id: socket.assigns.project_id,
      payment_date: DateTime.now("Etc/UTC")
    }
    save_payment!(payment)
    {:noreply, socket}
  end

  def handle_in("not_monetized", _payload, socket) do
    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    Pointers.subscribe_for_updates(socket.assigns.project_id)
    {:noreply, socket}
  end

  def handle_info({:pointer_update, pointers}, socket) do
    push(socket, "pointer-update", %{pointers: pointers})
    {:noreply, socket}
  end

  defp save_payment!(%{request_id: request_id, payment_pointer: payment_pointer} = payment_attrs) do
    Payments.save_and_broadcast_payment!(payment_attrs)
    :telemetry.execute([:wmhub, :payment, :received], %{count: 1}, %{request_id: request_id, payment_pointer: payment_pointer})
  end
end
