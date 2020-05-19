defmodule WmhubWeb.ProjectLive.PaymentPointersComponent do
  use WmhubWeb, :live_component

  alias Wmhub.Projects.Pointer

  def initial_assigns(socket) do
    socket
    |> assign(:add_new_pointer_state, :initial)
    |> assign(:edit_pointer_state, :initial)
  end

  def mount(socket) do
    {:ok, initial_assigns(socket)}
  end

  def render(assigns) do
    ~L"""
    <div id="<%= @id %>">
      <ul>
          <%= for pointer <- @project.payment_pointers do %>
              <%= pointer_partial(@edit_pointer_state, pointer, assigns) %>
          <% end %>
      </ul>
      <%= add_new_pointer_partial(@add_new_pointer_state, assigns) %>
    </div>
    """
  end

  def pointer_partial(:initial, %Pointer{id: id, payment_pointer: pointer}, assigns) do
    ~L"""
    <li class="collection-item" phx-click="start-edit-pointer" phx-value-project-pointer-id="<%= id %>" phx-target="<%= @myself %>">
      <span><%= pointer %></span> <i class="material-icons">edit</i> 
    </li>
    """
  end

  def pointer_partial(
        :editing,
        %Pointer{id: id},
        %{edited_pointer: %{id: id, pointer_value: pointer}} = assigns
      ) do
    ~L"""
    <%= f = form_for :edit_pointer_form, "#", [phx_submit: "save-edit-pointer", phx_change: "change-edit-pointer", phx_target: @myself] %>
        <%= label f, :pointer, "Edit Pointer" %>
        <%= text_input f, :pointer, value: pointer %>

        <%= submit "Save", class: "btn" %>
        <button type="button" phx-click="cancel-edit-pointer" class="btn grey" phx-target="<%= @myself %>">Discard</button>
    </form>
    """
  end

  def pointer_partial(:editing, %Pointer{payment_pointer: pointer}, assigns) do
    ~L"""
    <li><%= pointer %></li>
    """
  end

  def add_new_pointer_partial(_state, %{edit_pointer_state: :editing}), do: ""
  def add_new_pointer_partial(:initial, assigns) do
    ~L"""
    <button class="btn" phx-click="adding-pointer" phx-target="<%= @myself %>">Add Pointer</button>
    """
  end

  def add_new_pointer_partial(:adding, assigns) do
    ~L"""
    <%= f = form_for :new_pointer_form, "#", [phx_change: "set-new-pointer", phx_submit: "save-new-pointer", phx_target: @myself] %>
        <%= label f, :pointer %>
        <%= text_input f, :pointer, value: @new_pointer %>

        <%= submit "Add", class: "btn" %>
        <button type="button" phx-click="cancel-new-pointer" class="btn grey" phx-target="<%= @myself %>">Cancel</button>
    </form>
    """
  end

  def adding_new_pointer_assigns(socket) do
    socket
    |> assign(:add_new_pointer_state, :adding)
    |> assign(:new_pointer, "")
  end

  def reset_new_pointer_assigns(socket) do
    socket
    |> assign(:add_new_pointer_state, :initial)
    |> assign(:new_pointer, "")
  end

  def reset_editing_pointer_assigns(socket) do
    socket
    |> assign(:edit_pointer_state, :initial)
    |> assign(:edited_pointer, nil)
  end

  def editing_pointer_assigns(socket, edited_pointer) do
    socket
    |> assign(:edit_pointer_state, :editing)
    |> assign(:edited_pointer, edited_pointer)
  end

  def handle_event("adding-pointer", _params, socket) do
    {:noreply, adding_new_pointer_assigns(socket)}
  end

  def handle_event("set-new-pointer", %{"new_pointer_form" => %{"pointer" => pointer}}, socket) do
    {:noreply, assign(socket, :new_pointer, pointer)}
  end

  def handle_event("save-new-pointer", %{"new_pointer_form" => %{"pointer" => pointer}}, socket) do
    send(self(), {:new_pointer, pointer})
    {:noreply, reset_new_pointer_assigns(socket)}
  end

  def handle_event("cancel-new-pointer", _params, socket) do
    {:noreply, reset_new_pointer_assigns(socket)}
  end

  def handle_event("start-edit-pointer", %{"project-pointer-id" => project_pointer_id}, socket) do
    %Pointer{id: id, payment_pointer: pointer_value} =
      Enum.find(socket.assigns.project.payment_pointers, &(&1.id == project_pointer_id))

    {:noreply, editing_pointer_assigns(socket, %{id: id, pointer_value: pointer_value})}
  end

  def handle_event(
        "change-edit-pointer",
        %{"edit_pointer_form" => %{"pointer" => new_pointer_value}},
        socket
      ) do
    edited_pointer = socket.assigns.edited_pointer

    {:noreply,
     assign(socket, :edited_pointer, %{edited_pointer | pointer_value: new_pointer_value})}
  end

  def handle_event("save-edit-pointer", _params, socket) do
    %{id: id, pointer_value: pointer_value} = socket.assigns.edited_pointer
    send(self(), {:update_pointer, %{project_pointer_id: id, pointer_value: pointer_value}})
    {:noreply, reset_editing_pointer_assigns(socket)}
  end

  def handle_event("cancel-edit-pointer", _params, socket) do
    {:noreply, reset_editing_pointer_assigns(socket)}
  end
end
