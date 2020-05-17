defmodule WmhubWeb.SidebarComponent do
  use WmhubWeb, :live_component

  def render(assigns) do
    ~L"""
    <div class="sidenav sidenav-fixed">
        <ul id="nav-mobile">
            <li>
                <%= live_redirect "Home", to: Routes.dashboard_index_path(@socket, :index) %>
            </li>
            <li>
                <%= live_redirect "Projects", to: Routes.project_index_path(@socket, :index) %>
            </li>
        </ul>
    </div>
    """
  end
end
