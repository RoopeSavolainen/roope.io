defmodule RoopeIO do
  import Plug.Conn

  require Logger

  def init(options) do
    Logger.info "Launching server with #{options}"
    options
  end

  def call(conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Hello roope.io!")
  end

end
