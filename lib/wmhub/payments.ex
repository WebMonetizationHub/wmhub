defmodule Wmhub.Payments do
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

    def subscribe_new(user_id) do
        PubSub.subscribe(PubSubServer, new_payment_topic_for(user_id))
    end

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
  
    def save_and_broadcast_payment!(payment_attrs) do
        payment = %Payment{}
        |> Payment.changeset(payment_attrs)
        |> Repo.insert!()
        broadcast_new!(payment)
    end
end