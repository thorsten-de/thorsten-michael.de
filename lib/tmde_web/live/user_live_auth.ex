defmodule TmdeWeb.UserLiveAuth do
  import Phoenix.Component, only: [assign: 2]
  import Phoenix.LiveView, only: [redirect: 2]
  alias Tmde.Accounts
  alias TmdeWeb.Router.Helpers, as: Routes

  def on_mount(:default, _params, %{"user_id" => user_id} = _session, socket) do
    socket =
      socket
      |> assign(current_user: Accounts.get_user(user_id))

    if socket.assigns.current_user do
      {:cont, socket}
    else
      {:halt, redirect(socket, to: Routes.session_path(socket, :new))}
    end
  end
end
