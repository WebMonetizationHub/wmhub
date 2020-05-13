defmodule WmhubWeb.SnippetController do
    use WmhubWeb, :controller

    def index(conn, _params) do
        assigns = [
            payment_pointers: "https://wallet.example.com/sloan",
            project_id: UUID.uuid4(),
            wmhub_js_file: "http://localhost:4000/js/wmhub.js"
        ]

        render(conn, "snippet.js", assigns)
    end
end