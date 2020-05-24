defmodule WmhubWeb.LandingPageController do
  use WmhubWeb, :controller

  def index(conn, _params) do
    render(conn, "landing_page.html", layout: {WmhubWeb.LayoutView, :landing})
  end
end
