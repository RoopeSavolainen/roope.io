defmodule RoopeIOTest do
  use ExUnit.Case
  use Plug.Test

  @opts RoopeIO.init([])

  test "serves pages" do
    conn =
      :get
      |> conn("/about", "")
      |> RoopeIO.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
  end

  test "redirects root to home page" do
    conn =
      :get
      |> conn("/", "")
      |> RoopeIO.call(@opts)
    [dest] = get_resp_header(conn, "location")

    assert conn.state == :sent
    assert conn.status == 301
    assert dest == "/home"
  end

  test "returns 404 for nonexistant pages" do
    conn =
      :get
      |> conn("/nonexistant", "")
      |> RoopeIO.call(@opts)

    assert conn.state == :sent
    assert conn.status == 404
  end
end
