defmodule RoopeIO.PageCache do
  use Nebulex.Cache,
    otp_app: :roopeio,
    adapter: Nebulex.Adapters.Local
end
