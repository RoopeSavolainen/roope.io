defmodule RoopeIO.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    port = Application.get_env(:roopeio, :port)
    bind = Application.get_env(:roopeio, :bind)

    children = [
      {Plug.Cowboy, scheme: :http, plug: RoopeIO, ip: bind, port: port},
      {RoopeIO.PageCache, name: RoopeIO.PageCache},
      {RoopeIO.Page, name: RoopeIO.Page}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RoopeIO.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
