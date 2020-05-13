defmodule WmhubWeb.ProjectLive.PaymentPointersComponent do
    use WmhubWeb, :live_component

    alias Wmhub.Projects.ProjectsPointers

    def mount(socket) do
        {:ok, assign(socket, :state, :initial)}
    end

    def render(assigns) do
        ~L"""
        <div id="<%= @id %>">
            <h3>Payment Pointers</h3>
            <ul>
                <%= for %ProjectsPointers{payment_pointer: pointer} <- @project.payment_pointers do %>
                    <li><%= pointer %></li>
                <% end %>
            </ul>
            <%= template_snippet_for(@state, assigns) %>
        </div>
        """
    end

    def template_snippet_for(:initial, assigns) do
        ~L"""
        <button phx-click="adding-pointer" phx-target="<%= @myself %>">Add Pointer</button>
        """
    end

    def template_snippet_for(:adding, assigns) do
        ~L"""
        <%= f = form_for :new_pointer_form, "#", [phx_change: "set-new-pointer", phx_submit: "save-new-pointer", phx_target: @myself] %>
            <%= label f, :pointer, value: @new_pointer %>
            <%= text_input f, :pointer %>

            <%= submit "Add", class: "button" %>
            <button type="button" phx-click="cancel-new-pointer" class="button button-outline" phx-target="<%= @myself %>">Cancel</button>
        </form>
        """
    end

    def template_snippet_for(_state, _assigns), do: ""

    def adding_pointer_assigns(socket) do
        socket
        |> assign(:state, :adding)
        |> assign(:new_pointer, "")
    end

    def initial_pointer_assigns(socket) do
        socket
        |> assign(:state, :initial)
        |> assign(:new_pointer, "")
    end

    def handle_event("adding-pointer", _params, socket) do
        {:noreply, adding_pointer_assigns(socket)}
    end

    def handle_event("set-new-pointer", %{"new_pointer_form" => %{"pointer" => pointer}}, socket) do
        {:noreply, assign(socket, :new_pointer, pointer)}
    end

    def handle_event("save-new-pointer", %{"new_pointer_form" => %{"pointer" => pointer}}, socket) do
        send self(), {:new_pointer, pointer}
        {:noreply, initial_pointer_assigns(socket)}
    end

    def handle_event("cancel-new-pointer", _params, socket) do
        {:noreply, initial_pointer_assigns(socket)}
    end
end