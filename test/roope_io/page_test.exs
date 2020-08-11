defmodule PageTest do
  use ExUnit.Case

  test "renders basic markdown" do
    raw = ~S"""
    # Title

    Introduction

    ## Subtitle

    Content
    """

    expected = ~S"""
    <h1>Title</h1>

    <p>Introduction</p>

    <h2>Subtitle</h2>

    <p>Content</p>
    """

    rendered = RoopeIO.Page.render_content(raw)
    assert equal_html(rendered, expected)
  end

  test "renders code blocks" do
    raw = ~S"""
    # Code example
    
    ```bash
    $ ls
    ```
    """

    expected = ~S"""
    <h1>Code example</h1>

    <pre><code class="bash">$ ls</code></pre>
    """

    rendered = RoopeIO.Page.render_content(raw)
    assert equal_html(rendered, expected)
  end

  defp equal_html(actual, expected) do
    # Asserts that two strings are equal, not taking into account newlines
    String.replace(actual, "\n", "") == String.replace(expected, "\n", "")
  end
end
