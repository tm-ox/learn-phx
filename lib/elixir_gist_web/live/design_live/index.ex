defmodule ElixirGistWeb.DesignLive.Index do
  use ElixirGistWeb, :live_view

  def render(assigns) do
    ~H"""
    <section class="flex flex-col gap-12 justify-center items-center">
      <h1 class="h-2 p">Hi</h1>
      <.link class="menu-item">Test</.link>
    </section>
    """
  end
end
