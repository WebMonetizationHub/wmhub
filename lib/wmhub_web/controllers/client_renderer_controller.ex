defmodule WmhubWeb.ClientRendererController do
    use WmhubWeb, :controller

    def index(conn, %{"token" => token}) do
        anonymous_user_session = Phoenix.Token.sign(conn, "anonymous user", UUID.uuid4())
        assigns = [
            stuff: "I am stuff",
            payment_pointer: "https://wallet.example.com/sloan",
            session_id: anonymous_user_session,
            project_id: UUID.uuid4()
        ]

        render(conn, "client.js", assigns)
    end
end