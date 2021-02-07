defmodule EcomWeb.Router do
  use EcomWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug CORSPlug, origin: "*"
    plug :accepts, ["json"]
    plug EcomWeb.Plugs.UserContextPlug
  end

  scope "/", EcomWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api" do
    pipe_through :api

    forward "/graphql", Absinthe.Plug, schema: EcomWeb.Schema

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: EcomWeb.Schema,
      interface: :advanced,
      socket: EcomWeb.UserSocket

    # if Mix.env() == :dev do
    #   forward "/graphiql", Absinthe.Plug.GraphiQL,
    #     schema: ChatlyWeb.Schema,
    #     interface: :advanced,
    #     socket: ChatlyWeb.UserSocket
    # end
  end

  # Other scopes may use custom stacks.
  # scope "/api", EcomWeb do
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
      live_dashboard "/dashboard", metrics: EcomWeb.Telemetry
    end
  end
end
