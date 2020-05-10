defmodule WmhubWeb.ClientRendererController do
    use WmhubWeb, :controller

    def index(conn, _params) do
        anonymous_user_session = Phoenix.Token.sign(conn, "anonymous user", UUID.uuid4())
        assigns = [
            payment_pointer: "https://wallet.example.com/sloan",
            session_id: anonymous_user_session,
            project_id: UUID.uuid4(),
            wmhub_js_file: "http://localhost:4000/js/wmhub.js"
        ]

        render(conn, "client.js", assigns)
    end
end