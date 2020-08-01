import Config

config :roopeio, :port, 8080

if Mix.env() == :prod do
  config :roopeio, :bind, {127,0,0,1}
else
  config :roopeio, :bind, {0,0,0,0}
end
