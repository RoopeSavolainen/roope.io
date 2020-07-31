defmodule RoopeIO.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    port = Application.get_env(:roopeio, :port)

    children = [
      Supervisor.child_spec({Task, fn -> RoopeIO.serve(port) end}, restart: :permanent)
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RoopeIO.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
