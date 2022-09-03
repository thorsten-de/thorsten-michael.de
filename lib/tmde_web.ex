defmodule TmdeWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use TmdeWeb, :controller
      use TmdeWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: TmdeWeb

      import Plug.Conn
      import TmdeWeb.Gettext
      import TmdeWeb.Plugs.Page, only: [set_metadata: 2]
      alias TmdeWeb.Router.Helpers, as: Routes
    end
  end

  @doc """
  Allows simple rendering of co-located .heex files for
  functional components. If you have a module named `Components.Layout`
  in the `components`folder with a functional component `page(assigns)`,
  you can use `render("page.html", assigns)` to render a template at
  `components/layout/page.html.heex`
  """
  def colocate_templates do
    quote do
      use Phoenix.View,
        root: "lib/tmde_web/components",
        namespace: TmdeWeb.Components
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/tmde_web/templates",
        namespace: TmdeWeb

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      # Include shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {TmdeWeb.LayoutView, "live.html"}

      unquote(view_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(view_helpers())
    end
  end

  def component do
    quote do
      use Phoenix.Component

      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import TmdeWeb.Gettext
    end
  end

  defp view_helpers do
    quote do
      # Use all HTML functionality (forms, tags, etc)
      # instead of use Phoenix.HTML, I'll import them to exclude functions clashing with
      # my Bulma components, eg: label
      import Phoenix.HTML
      import Phoenix.HTML.Form, except: [label: 1]
      import Phoenix.HTML.Link
      import Phoenix.HTML.Tag, except: [attributes_escape: 1]
      import Phoenix.HTML.Format

      # Import LiveView and .heex helpers (live_render, live_patch, <.form>, etc)
      import Phoenix.LiveView.Helpers

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      # Include my own Bulma components
      use Bulma

      import TmdeWeb.ErrorHelpers
      import TmdeWeb.Gettext
      alias TmdeWeb.Router.Helpers, as: Routes
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
