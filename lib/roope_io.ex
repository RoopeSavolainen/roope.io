defmodule RoopeIO do
  require Logger

  @doc """
  Main server function.
  Sets up cowboy and starts serving content.
  """
  def serve(port) do
    Logger.info "Starting server on port #{port}"
  end
end
