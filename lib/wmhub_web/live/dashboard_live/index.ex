defmodule WmhubWeb.DashboardLive.Index do
  use WmhubWeb, :live_view
  alias Wmhub.Payments

  def mount(_params, %{"current_user" => current_user}, socket) do
    if connected?(socket) do
      Payments.subscribe_new(current_user.id)
    end
    {:ok, assign(socket, :amount, 0)}
  end

  def render(assigns) do
    ~L"""
    <h1>cool. cool cool cool.</h1>
    <h3>A gente devia por uns stats aqui, uns gráficos, umas parada.</h3>
    <%= format_float(@amount, decimals: 9) %>
    """
  end

  def format_float(0, _opts), do: 0
  def format_float(f, opts), do: :erlang.float_to_binary(f, opts)

  def handle_info({:new_payment, payment}, socket) do
    amount = socket.assigns.amount + payment.amount
    amount = amount / (:math.pow(10, payment.asset_scale))
    {:noreply, assign(socket, :amount, amount)}
  end
end
