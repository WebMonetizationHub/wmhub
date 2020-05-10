defmodule WmhubWeb.ClientRendererController do
    use WmhubWeb, :controller

    def index(conn, %{"token" => token}) do
        render(conn, "client.js", stuff: "I am stuff", payment_pointer: "$wallet.example.com/sloan")
    end
end