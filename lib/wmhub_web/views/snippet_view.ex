defmodule WmhubWeb.SnippetView do
    use WmhubWeb, :view

    def get_script_options(assigns) do
        assigns
        |> Map.take([:payment_pointers, :project_id])
        |> Jason.encode!()
    end
end