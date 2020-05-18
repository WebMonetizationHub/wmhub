defmodule WmhubWeb.SnippetView do
  use WmhubWeb, :view

  def get_script_options(assigns) do
    assigns
    |> Map.take([:project_id])
    |> Phoenix.json_library().encode!()
  end
end
