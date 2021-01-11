defmodule TutorialAuthWeb.PageController do
  use TutorialAuthWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
