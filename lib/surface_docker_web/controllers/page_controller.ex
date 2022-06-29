defmodule SurfaceDockerWeb.PageController do
  use SurfaceDockerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
