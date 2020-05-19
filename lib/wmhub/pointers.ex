defmodule Wmhub.Pointers do
  import Ecto.Query, warn: false
  alias Phoenix.PubSub
  alias Wmhub.PubSub, as: PubSubServer
  alias Wmhub.Projects.Pointer
  alias Wmhub.Repo

  @topic "pointers"

  defp update_topic(project_id) do
    "#{@topic}:#{project_id}:update"
  end

  def subscribe_for_updates(project_id) do
    PubSub.subscribe(PubSubServer, update_topic(project_id))
  end

  def broadcast_update!(project_id, pointers) do
    PubSub.broadcast!(PubSubServer, update_topic(project_id), {:pointer_update, pointers})
  end

  def pointers_for(project_id) do
    Repo.all(from p in Pointer, where: p.project_id == ^project_id, select: p.payment_pointer)
  end
end
