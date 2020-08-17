import Config

config :roopeio, :port, 8080
config :roopeio, RoopeIO.PageCache,
  gc_interval: 86_400,          # 24 hrs
  allocated_memory: 10_000_000  # 10 MB

if Mix.env() == :prod do
  config :roopeio, :bind, {127,0,0,1}
else
  config :roopeio, :bind, {0,0,0,0}
end
