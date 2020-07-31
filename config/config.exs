import Config

if Mix.env() == :prod do
  config :roopeio, :port, 80
else
  config :roopeio, :port, 8080
end
