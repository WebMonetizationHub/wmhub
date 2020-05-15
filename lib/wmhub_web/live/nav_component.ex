defmodule WmhubWeb.NavComponent do
    use WmhubWeb, :live_component

    def render(assigns) do
        ~L"""
        <%= live_redirect "Home", to: Routes.dashboard_index_path(@socket, :index) %>
        <%= live_redirect "Projects", to: Routes.project_index_path(@socket, :index) %>
        """
    end
end