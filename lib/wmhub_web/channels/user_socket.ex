defmodule WmhubWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  # channel "room:*", WmhubWeb.RoomChannel
  channel "monetization:*", WmhubWeb.MonetizationChannel

  @impl true
  def connect(%{"sessionId" => session_id}, socket, _connect_info) do
    {:ok, assign(socket, :session_id, session_id)}
  end

  def connect(_params, socket, _connect_info), do: {:error, "not allowed"}

  @impl true
  def id(socket), do: "user_socket:#{socket.assigns.session_id}"
end
