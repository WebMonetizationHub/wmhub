defmodule WmhubWeb.Router do
  use WmhubWeb, :router
  use Pow.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :fetch_flash
    plug :put_root_layout, {WmhubWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :require_authenticated do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
    plug :live_view_current_user
  end

  defp live_view_current_user(conn, _params) do
    put_session(conn, :current_user, conn.assigns.current_user)
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :js do
    plug :put_secure_browser_headers
    plug :put_js_content_type
  end

  defp put_js_content_type(conn, _params) do
    Plug.Conn.put_resp_content_type(conn, "text/javascript")
  end
  
  scope "/" do
    pipe_through :browser
    
    pow_routes()
  end

  scope "/", WmhubWeb do
    pipe_through :browser
    get "/", PageController, :index
  end

  scope "/app", WmhubWeb do
    pipe_through [:browser, :require_authenticated]

    live "/projects", ProjectLive.Index, :index
    live "/projects/new", ProjectLive.Index, :new
    live "/projects/:id/edit", ProjectLive.Index, :edit

    live "/projects/:id", ProjectLive.Show, :show
    live "/projects/:id/show/edit", ProjectLive.Show, :edit
  end

  scope "/", WmhubWeb do
    pipe_through :js

    get "/wmhub.js", SnippetController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", WmhubWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: WmhubWeb.Telemetry
    end
  end
end
