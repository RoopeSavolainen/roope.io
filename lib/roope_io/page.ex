defmodule RoopeIO.Page do
  @doc ~S"""
  Reads the given file `file` from the assets directory, optionally found in 
  subdirectory `directory` and renders it with markdown and templating applied.
  """
  def render_file(page, directory \\ "") do
    path = Path.join(["assets", directory, page])
    case File.read(path) do
      {:ok, template} ->
        {:ok, render_content(template)}
      _ -> {:error, :page_not_found}
    end
  end

  @doc ~S"""
  Renders the given `content` with markdown and templating applied.
  """
  def render_content(content) do
    Earmark.as_html!(content)
  end
end
