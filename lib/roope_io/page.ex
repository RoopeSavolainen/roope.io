defmodule RoopeIO.Page do
  @doc ~S"""
  Reads the given file `page` from the assets directory, optionally found in 
  subdirectory `directory` and returns its contents.
  """
  def render_page(page, directory \\ "") do
    path = Path.join(["assets", directory, page])
    case File.read(path) do
      {:ok, template} ->
        {:ok, Earmark.as_html!(template)}
      _ -> {:error, :page_not_found}
    end
  end
end
