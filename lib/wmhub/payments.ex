defmodule Wmhub.Payments do
    @moduledoc """
    The Payments context. Groups everything related to payments.
    
    A Payment is a web monetization microtransaction that is streamed from web monetization
    event handlers from every connected client to our websocket server running on Phoenix Channel.
    """
    import Ecto.Query, warn: false
    alias Phoenix.PubSub
    alias Wmhub.PubSub, as: PubSubServer
    alias Wmhub.Projects.{Payment, Project}
    alias Wmhub.Accounts.User
    alias Wmhub.Repo

    @topic "payments"

    defp new_payment_topic_for(user_id) do
        "#{@topic}:#{user_id}:new"
    end

    defp payment_query do
        from pa in Payment,
            join: pr in Project, on: pr.id == pa.project_id,
            join: u in User, on: u.id == pr.user_id
    end

    @doc """
    Subscribes the given process to a new payment occurring.
    """
    def subscribe_new(user_id) do
        PubSub.subscribe(PubSubServer, new_payment_topic_for(user_id))
    end

    @doc """
    Broadcasts a new payment to the user_id of said payment. This is done
    to simplify subscribing, since in the dashboard we only need to know the
    currently logged in user to receive payment streams.

    This should be massively reworked in the future.
    """
    def broadcast_new!(%Payment{} = payment) do
        query = payment_query()
        user_id = Repo.one!(
            from [..., project, user] in query,
            select: user.id,
            where: project.id == ^payment.project_id,
            limit: 1
        )
        PubSub.broadcast!(PubSubServer, new_payment_topic_for(user_id), {:new_payment, payment})
    end

    # TODO: fix, not working
    # ** (Postgrex.Error) ERROR 42803 (grouping_error) column "p0.id" must appear in the GROUP BY clause or be used in an aggregate function
    @doc false
    def payments_for(user_id) do
        query = payment_query()
        Repo.all(
            from [payment, project, user] in query,
            select: %{
                project: project,
                payment: payment,
                sum: sum(payment.amount)
            },
            where: user.id == ^user_id,
            group_by: [payment.request_id, project.id]
        )
    end

    @doc """
    Validates, saves and broadcasts the given attributes referring to a `Wmhub.Projects.Payment`.
    Raises if there is an error saving or broadcasting the Payment. Does not run in a transaction.
    """
    def save_and_broadcast_payment!(payment_attrs) do
        payment = %Payment{}
        |> Payment.changeset(payment_attrs)
        |> Repo.insert!()
        broadcast_new!(payment)
    end
end