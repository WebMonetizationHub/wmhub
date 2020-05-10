defmodule WmhubWeb.PageController do
    use WmhubWeb, :controller

    def index(conn, _params) do
        render(conn, "page.html")
    end
end