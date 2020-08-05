defmodule RoopeIO do
  use Plug.Router
  use Plug.ErrorHandler

  require Logger

  plug :match
  plug :dispatch

  get "/" do
    conn
    |> redirect("/home")
  end

  get "/:page" do
    send_resp(conn, 200, "Page #{page}")  # TODO: render the actual page
  end

  match _ do
    send_resp(conn, 404, "Page not found.")  # TODO: proper error page
  end

  defp redirect(conn, to) do
    url = Plug.HTML.html_escape(to)
    body = "<html><body>You are being redirected to <a href=\"#{url}\">#{url}</a>.</body></html>"

    conn
    |> put_resp_header("location", url)
    |> send_resp(301, body)
  end
end
