# Plug Test Helpers

Simple helpers to test your [Plugs](https://github.com/elixir-lang/plug) with ExUnit. Still an experiment in progress at this point.

The library provides a set of macros which can perform assertions on `Plug.Conn` structs to verify the response status, headers and body.

## Installation

Add the dependency in your `mix.exs` file:

```elixir
def deps do
  [ { :plug_test_helpers, "~> 0.1" } ]
end
```

After you are done, run `mix deps.get` in your shell to get install it.

## Usage

Add `use PlugTestHelpers` to your test case to bring in new Plug-specific assert macros :

```elixir

defmodule do
  use ExUnit.Case, async: true

  use Plug.Test
  use PlugTestHelpers

  @opts MyPlug.init([])

  test "status" do
    conn = conn(:get, "/")
    conn = MyPlug.call(conn, @opts)
    assert_status 200
  end

  test "404" do
    conn = conn(:get, "/not-found")
    conn = MyPlug.call(conn, @opts)
    # Works with symbols toos
    assert_status :not_found
  end

  test "redirect" do
    conn = conn(:get, "/redirect")
    conn = MyPlug.call(conn, @opts)
    # Will check both HTTP status code and header
    assert_redirect "http://example.com"
  end

  test "headers" do
    conn = conn(:get, "/image.jpg")
    conn = MyPlug.call(conn, @opts)
    # Will pass if the header is present
    assert_header "content_type"
    # Will pass if the header value is set to the given string
    assert_header "content_type", "image/jpg"
    # Will pass if the header value matches the given regex
    assert_header_match "content_type", ~r/\Aimage\/jpe?g\Z/
  end

  test "body" do
    conn = conn(:get, "/")
    conn = MyPlug.call(conn, @opts)
    # Will pass if the response body is the given string
    assert_body "complete response text"
    # Will pass if the response body matches the given regex
    assert_body_match ~r/complete/
  end

end

```

## Current Design Decisions

Things may always change but these are the current design decisions taken to build this library.

### Convention over Configuration

Each of the `assert` macros expect a variable named `conn` to be bound to a `Plug.Conn`.

This is definitely a questionable design decision and I'd be very happy ot get some feedback about this.

I think it's nice to have tests that are simple and concise. Is it worth providing macros accepting an extra `conn` parameter?

### Advanced Response Body Assertions

Assertions to match against structured response content (such as HTML or JSON) are currently out of the scope of this library.

## License

Copyright 2014 Xavier Defrang

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

```
http://www.apache.org/licenses/LICENSE-2.0
```

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.