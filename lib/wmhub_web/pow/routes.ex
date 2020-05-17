defmodule WmhubWeb.Pow.Routes do
  use Pow.Phoenix.Routes
  alias WmhubWeb.Router.Helpers, as: Routes

  @impl true
  def after_sign_in_path(conn), do: Routes.dashboard_index_path(conn, :index)
end
