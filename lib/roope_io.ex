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
    {status, content} = case RoopeIO.Page.render_file(page, "pages") do
      {:ok, content} ->
        {200, content}
      {:error, :page_not_found} ->
        {404, error(404, "Page not found")}
      _ ->
        {501, error(501, "Internal server error")}
    end
    send_resp(conn, status, content)
  end

  get "/blog/:entry" do
    {status, content} = case RoopeIO.Page.render_file(entry, "blog") do
      {:ok, content} ->
        {200, content}
      {:error, :page_not_found} ->
        {404, error(404, "Page not found")}
      _ ->
        {501, error(501, "Internal server error")}
    end
    send_resp(conn, status, content)
  end

  match _ do
    send_resp(conn, 404, error(404, "Page not found."))
  end

  defp error(code, description) do
    content = """
    # Error #{code}
    
    #{description}
    """
    RoopeIO.Page.render_content(content)
  end

  defp redirect(conn, to) do
    url = Plug.HTML.html_escape(to)
    body = "<html><body>You are being redirected to <a href=\"#{url}\">#{url}</a>.</body></html>"

    conn
    |> put_resp_header("location", url)
    |> send_resp(301, body)
  end
end
