defmodule Wmhub.Pointers do
    alias Phoenix.PubSub
    alias Wmhub.PubSub, as: PubSubServer
    @topic "pointers:"

    defp update_topic(project_id) do
        "#{@topic}:#{project_id}:update"
    end

    def subscribe_for_updates(project_id) do
        PubSub.subscribe(PubSubServer, update_topic(project_id))
    end

    def broadcast_update!(project_id, pointers) do
        PubSub.broadcast!(PubSubServer, update_topic(project_id), {:pointer_update, pointers})
    end
end