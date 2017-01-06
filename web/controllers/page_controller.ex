defmodule BlackSwan.PageController do
  use BlackSwan.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
