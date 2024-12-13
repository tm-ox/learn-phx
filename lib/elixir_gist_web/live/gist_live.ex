defmodule ElixirGistWeb.GistLive do
  use ElixirGistWeb, :live_view

  embed_templates "../components/layouts/components/*"
  alias ElixirGist.Gists

  def mount(%{"id" => id}, _session, socket) do
    gist = Gists.get_gist!(id)
    {:ok, assign(socket, gist: gist)}
  end
end
