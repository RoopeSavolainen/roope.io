defmodule RoopeIO.Page do
  require EEx
  require Logger
  use Nebulex.Caching.Decorators
  use Agent

  @doc ~S"""
  Starts watching for file changes in the assets folder. Invalidates
  the page cache entries whenever a file is modified.
  """
  def start_link(_opts \\ []) do
    {:ok, pid} = FileSystem.start_link(dirs: ["assets"])
    FileSystem.subscribe(pid)
    file_watcher(pid)
  end

  defp file_watcher(pid) do
    receive do
      {:file_event, ^pid, {path, [:modified, :closed]}} ->
        basedir = Path.absname("assets")
        pattern = ~r/#{basedir}\/(?<dir>.*)\/(?<page>.*)\.md/
        case Regex.named_captures(pattern, path) do
          %{"dir" => dir, "page" => page} ->
            RoopeIO.PageCache.delete({dir, page})
          _ -> nil
        end
      _ -> nil
    end
    file_watcher(pid)
  end

  @doc ~S"""
  Reads the given file `file` from the assets directory, optionally found in 
  subdirectory `directory` and renders it with markdown and templating applied.
  """
  def render_file(page, directory \\ "") do
    case get_page_contents(page, directory) do
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

  @decorate cache(cache: RoopeIO.PageCache, key: {directory, page})
  defp get_page_contents(page, directory) do
    path = Path.join(["assets", directory, page <> ".md"])
    Logger.debug("Loading page contents from #{path}")
    case File.read(path) do
      {:ok, content} -> {:ok, content}
      _ -> {:error, :page_not_found}
    end
  end
end
