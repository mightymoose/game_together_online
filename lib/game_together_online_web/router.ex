defmodule GameTogetherOnlineWeb.Router do
  use GameTogetherOnlineWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {GameTogetherOnlineWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GameTogetherOnlineWeb do
    pipe_through :browser

    get "/games/new", GameController, :new
    get "/games/:game_id/join", GameController, :join

    live "/", PageLive, :index
    live "/games/:game_id", GameLive, :show

    resources "/users", UserController, except: [:index, :show, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", GameTogetherOnlineWeb do
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
      live_dashboard "/dashboard", metrics: GameTogetherOnlineWeb.Telemetry
    end
  end
end
