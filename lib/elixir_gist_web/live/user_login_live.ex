defmodule ElixirGistWeb.UserLoginLive do
  use ElixirGistWeb, :live_view

  def render(assigns) do
    ~H"""
    <.header class="text-center page-header">
      <h1>Log in to account</h1>
      <:subtitle>
        Don't have an account?
        <.link navigate={~p"/users/register"} class="font-semibold text-brand hover:underline">
          Sign up
        </.link>
        for an account now.
      </:subtitle>
    </.header>

    <section>
      <.simple_form for={@form} id="login_form" action={~p"/users/log_in"} phx-update="ignore">
        <.input field={@form[:email]} type="email" label="Email" required />
        <.input field={@form[:password]} type="password" label="Password" required />

        <:actions>
          <.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in" />
          <.link href={~p"/users/reset_password"} class="text-sm font-semibold">
            Forgot your password?
          </.link>
        </:actions>
        <:actions>
          <.button phx-disable-with="Logging in..." class="default-button mx-auto">
            Log in <span aria-hidden="true">→</span>
          </.button>
        </:actions>
      </.simple_form>
    </section>
    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
