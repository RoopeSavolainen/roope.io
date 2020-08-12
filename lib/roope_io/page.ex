defmodule RoopeIO.Page do
  require EEx

  @doc ~S"""
  Reads the given file `file` from the assets directory, optionally found in 
  subdirectory `directory` and renders it with markdown and templating applied.
  """
  def render_file(page, directory \\ "") do
    path = Path.join(["assets", directory, page <> ".md"])
    case File.read(path) do
      {:ok, content} ->
        rendered = render_content(content)
                   |> main_template("roope.io")  # TODO: Derive title from displayed page
        {:ok, rendered}
      _ -> {:error, :page_not_found}
    end
  end

  EEx.function_from_file(:defp, :main_template, Path.join("assets", "main.html"), [:content, :title])

  @doc ~S"""
  Renders the given `content` with markdown and templating applied.
  """
  def render_content(raw) do
    EEx.eval_string(raw)
    |> Earmark.as_html!
  end
end
