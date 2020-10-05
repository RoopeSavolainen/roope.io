defmodule RoopeIO.Page do
  require EEx
  require Logger
  use Nebulex.Caching.Decorators
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    {:ok, pid} = FileSystem.start_link(dirs: ["assets"])
    FileSystem.subscribe(pid)
    {:ok, %{}}
  end

  @doc ~S"""
  Handle file events and invalidate cache entries for modified
  pages.
  """
  def handle_info({:file_event, _pid, {path, events}}, state) do
    if :modified in events do
      basedir = Path.absname("assets")
      pattern = ~r/#{basedir}\/(?<dir>.*)\/(?<page>.*)\.md/
      case Regex.named_captures(pattern, path) do
        %{"dir" => dir, "page" => page} ->
          RoopeIO.PageCache.delete({dir, page})
        _ -> nil
      end
    end
    {:noreply, state}
  end

  @doc ~S"""
  If the file watcher crashes, panic.
  """
  def handle_info({:file_event, _pid, :stop}, _state) do
    raise RuntimeError
  end

  defp render(content) do
    title = case get_title(content) do
      {:ok, val} -> val
      {:error, :not_found} -> "roope.io"
    end

    content
    |> Earmark.as_html!
    |> main_template(title)
  end

  def handle_call({:page, page, directory}, _from, state) do
    case get_page_contents(page, directory) do
      {:ok, content} -> {:reply, {:ok, render(content)}, state}
      _ -> {:reply, {:error, :page_not_found}, state}
    end
  end

  def handle_call({:content, content}, _from, state) do
    {:reply, render(content), state}
  end

  @doc ~S"""
  Reads the given file `file` from the assets directory, optionally found in 
  subdirectory `directory` and renders it with markdown and templating applied.
  """
  @decorate cache(cache: RoopeIO.PageCache, key: {directory, page})
  def render_file(page, directory \\ "") do
    GenServer.call(__MODULE__, {:page, page, directory})
  end

  EEx.function_from_file(:defp, :main_template, Path.join("assets", "main.html"), [:content, :title])

  @doc ~S"""
  Renders the given `content` with markdown and templating applied.
  """
  def render_content(raw) do
    GenServer.call(__MODULE__, {:content, raw})
  end

  defp get_title(markdown) do
    pattern = ~r/^# (?<title>.*)$/m
    case Regex.named_captures(pattern, markdown) do
      %{"title" => title} -> {:ok, title}
      _ -> {:error, :not_found}
    end
  end

  defp get_page_contents(page, directory) do
    path = Path.join(["assets", directory, page <> ".md"])
    Logger.debug("Loading page contents from #{path}")
    case File.read(path) do
      {:ok, content} -> {:ok, content}
      _ -> {:error, :page_not_found}
    end
  end
end
