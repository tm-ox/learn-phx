defmodule ElixirGistWeb.GistLive do
  use ElixirGistWeb, :live_view
  alias ElixirGistWeb.Components.GistForm

  embed_templates "../components/layouts/components/*"

  alias ElixirGist.Gists

  def mount(%{"id" => id}, _session, socket) do
    gist = Gists.get_gist!(id)

    {:ok, relative_time} = Timex.format(gist.updated_at, "{relative}", :relative)
    gist = Map.put(gist, :relative, relative_time)
    {:ok, assign(socket, gist: gist)}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    case Gists.delete_gist(socket.assigns.current_user, id) do
      {:ok, _gist} ->
        socket = put_flash(socket, :info, "Gist Successfully Deleted")
        {:noreply, push_navigate(socket, to: ~p"/create")}

      {:error, message} ->
        socket = put_flash(socket, :error, message)
        {:noreply, socket}
    end
  end

  def handle_event("copy-gist", _params, socket) do
    {:noreply, put_flash(socket, :info, "Gist Copied to Clipboard")}
  end
end
