defmodule ElixirGistWeb.Components.GistForm do
  use ElixirGistWeb, :live_component

  alias ElixirGist.{Gists, Gists.Gist}

  def mount(socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <section class="flex-grow">
      <.form
        for={@form}
        phx-submit="create"
        phx-change="validate"
        class="flex flex-col flex-grow gap-3"
        phx-target={@myself}
      >
        <.input
          field={@form[:description]}
          placeholder="Gist description..."
          autocomplete="off"
          phx-debounce="blur"
        />
        <div class="flex flex-col flex-grow">
          <div class="gist-header pt-1">
            <.input
              field={@form[:name]}
              placeholder="Filename + extension..."
              autocomplete="off"
              phx-debounce="blur"
            />
            <%= if @id == :new do %>
              <.button
                phx-disable-with="creating..."
                class="bg-background hover:bg-accent px-4 !py-1 ml-auto rounded-md mt-2"
              >
                Create Gist
              </.button>
            <% else %>
              <.button
                phx-disable-with="updatingg..."
                class="bg-background hover:bg-accent px-4 !py-1 ml-auto rounded-md mt-2"
              >
                Update Gist
              </.button>
            <% end %>
          </div>
          <div id="gist-wrapper" class="gist-body" phx-update="ignore">
            <textarea
              id="line-numbers"
              readonly
              class="h-fill w-[52px] text-right overflow-hidden resize-none border-none focus:outline-none text-sm leading-6 "
            >
            <%= "1\n" %>
            </textarea>
            <.input
              type="textarea"
              id="gist-textarea"
              phx-hook="UpdateLineNumbers"
              field={@form[:markup_text]}
              placeholder="Insert code..."
              spellcheck="false"
              autocomplete="off"
              phx-debounce="blur"
              class="flex-grow !bg-text"
            />
          </div>
        </div>
      </.form>
    </section>
    """
  end

  def handle_event("validate", %{"gist" => params}, socket) do
    changeset =
      %Gist{}
      |> Gists.change_gist(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  def handle_event("create", %{"gist" => params}, socket) do
    if is_nil(params["id"]) do
      create_gist(params, socket)
    else
      update_gist(params, socket)
    end
  end

  defp create_gist(params, socket) do
    case Gists.create_gist(socket.assigns.current_user, params) do
      {:ok, gist} ->
        socket = push_event(socket, "clear-textareas", %{})
        changeset = Gists.change_gist(%Gist{})
        socket = assign(socket, :form, to_form(changeset))
        {:noreply, push_navigate(socket, to: ~p"/gist?#{[id: gist]}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp update_gist(params, socket) do
    case Gists.update_gist(socket.assigns.current_user, params) do
      {:ok, gist} ->
        {:noreply, push_patch(socket, to: ~p"/gist?#{[id: gist]}")}

      {:error, message} ->
        socket = put_flash(socket, :error, message)
        {:noreply, socket}
    end
  end
end
