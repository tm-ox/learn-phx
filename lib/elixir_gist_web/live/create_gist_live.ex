defmodule ElixirGistWeb.CreateGistLive do
  use ElixirGistWeb, :live_view
  alias ElixirGistWeb.Components.GistForm
  alias ElixirGist.{Gists, Gists.Gist}

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="page-header">
      <h1 class="text-center content-width">Instantly share code, notes & snippets.</h1>
    </div>
    <.live_component
      module={GistForm}
      id={:new}
      current_user={@current_user}
      form={to_form(Gists.change_gist(%Gist{}))}
    />
    """
  end
end
