defmodule EcomWeb.PageController do
  use EcomWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
