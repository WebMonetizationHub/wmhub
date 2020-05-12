defmodule WmhubWeb.ClientRendererView do
    use WmhubWeb, :view

    def get_script_options(assigns) do
        assigns
        |> Map.take([:payment_pointer, :project_id, :session_id])
        |> Jason.encode!()
    end
end