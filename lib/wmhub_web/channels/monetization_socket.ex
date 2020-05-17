defmodule WmhubWeb.MonetizationSocket do
  use Phoenix.Socket

  ## Channels
  channel "monetization:*", WmhubWeb.MonetizationChannel

  @impl Phoenix.Socket
  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  @impl Phoenix.Socket
  def id(_socket), do: nil
end
