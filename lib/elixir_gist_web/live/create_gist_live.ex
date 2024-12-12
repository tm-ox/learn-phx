defmodule ElixirGistWeb.CreateGistLive do
  alias ElixirGist.Gists.Gist
  use ElixirGistWeb, :live_view

  alias ElixirGist.{Gists, Gists.Gist}

  def mount(_params, _session, socket) do
    socket =
      assign(
        socket,
        form: to_form(Gists.change_gist(%Gist{}))
      )

    {:ok, socket}
  end
end
