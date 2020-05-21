defmodule Wmhub.Pointers do
  @moduledoc """
  The Pointers context groups functionality related to payment pointers.
  It has functions that deal with reading and broadcasting updates to Pointers in Projects.
  """
  import Ecto.Query, warn: false
  alias Phoenix.PubSub
  alias Wmhub.PubSub, as: PubSubServer
  alias Wmhub.Projects.Pointer
  alias Wmhub.Repo

  @topic "pointers"

  defp update_topic(project_id) do
    "#{@topic}:#{project_id}:update"
  end

  @doc """
  Subscribes the given PID to updates to this pointer.
  """
  def subscribe_for_updates(project_id) do
    PubSub.subscribe(PubSubServer, update_topic(project_id))
  end

  @doc """
  Broadcasts a pointer update to this project
  """
  def broadcast_update!(project_id, pointers) do
    PubSub.broadcast!(PubSubServer, update_topic(project_id), {:pointer_update, pointers})
  end

  @doc """
  Gets a list of pointers for a project
  """
  def pointers_for(project_id) do
    Repo.all(from p in Pointer, where: p.project_id == ^project_id, select: p.payment_pointer)
  end
end
