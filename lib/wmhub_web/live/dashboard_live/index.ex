defmodule WmhubWeb.DashboardLive.Index do
    use WmhubWeb, :live_view

    def render(assigns) do
        ~L"""
        <h1>cool. cool cool cool.</h1>
        <h3>A gente devia por uns stats aqui, uns gráficos, umas parada.</h3>
        <canvas id="projects-earnings-chart" phx-data="<%= Jason.encode!([1, 2, 3]) %>" phx-hook="ProjectEarningsChart"></canvas>
        """
    end
end