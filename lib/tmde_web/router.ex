defmodule TmdeWeb.Router do
  use TmdeWeb, :router
  alias TmdeWeb.Plugs

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TmdeWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Plugs.Locale
    plug Plugs.Auth

    plug Plugs.Page,
      locale: Application.get_env(:gettext, :default_locale),
      author: "Thorsten-Michael Deinert",
      description: "Persönliche Homepage von Thorsten-Michael Deinert."
  end

  pipeline :requires_auth do
    plug Plugs.EnsureAuthenticated
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TmdeWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/impressum", PageController, :imprint
    resources "/sessions", SessionController, only: [:new, :create]

    get "/email/tmd-logo.svg", DeliveryController, :logo_logger
    get "/bewerbung/:token/dokumente/:slug", JobsController, :download_document

    get "/blog/:id", BlogController, :show

    live_session :jobs, on_mount: [TmdeWeb.LocaleLive] do
      live "/bewerbung/:token", JobsLive, :show
    end
  end

  scope "/profile", TmdeWeb do
    live_session :profile, on_mount: [TmdeWeb.UserLiveAuth, TmdeWeb.LocaleLive] do
      pipe_through [:browser, :requires_auth]

      live "/", Admin.ProfileLive, :index

      scope "/application" do
        live "/", Admin.ApplicationLive, :new
        live "/:id", Admin.ApplicationLive, :show
        live "/:id/preview", JobsLive, :show, as: :jobs_preview

        get "/:id/document/:slug", JobsController, :download_document, as: :document_preview
      end
    end
  end

  scope "/", TmdeWeb do
    pipe_through [:browser, :requires_auth]
    resources "/sessions", SessionController, only: [:delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", TmdeWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TmdeWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
