defmodule PlugTestHelpers do

  defmacro assert_status(expected_code) when is_integer(expected_code) do
    quote do
      status = var!(conn).status
      assert status == unquote(expected_code), "Expected status #{unquote(expected_code)}, got #{status}"
    end
  end

  @atom_to_status %{
    ok: 200,
    success: 200,
    created: 201,
    pending: 202,
    no_content: 204,
    partial: 206,

    permanent_redirect: 301,
    redirect: 302,

    bad_request: 400,
    authentication_failed: 401,
    forbidden: 403,
    not_found: 404,
    not_acceptable: 406,

    internal_server_error: 500,
  }

  @status_atoms Dict.keys(@atom_to_status)

  defmacro assert_status(expected_code) when is_atom(expected_code) and expected_code in @status_atoms do
    expected_code = Dict.fetch!(@atom_to_status, expected_code)
    quote do
      status = var!(conn).status
      assert status == unquote(expected_code), "Expected status #{unquote(expected_code)}, got #{status}"
    end
  end

  defmacro assert_status(other) do
    quote do
      raise ExUnit.AssertionError, message: "Unknown status: #{unquote(other)}"
    end
  end

  defmacro assert_redirect do
    quote do
      assert_status :redirect
    end
  end

  defmacro assert_redirect(expected_url) do
    quote do
      assert_status :redirect
      assert_header "location", unquote(expected_url)
    end
  end

  defmacro assert_header(key, expected_value) do
    quote do
      case Plug.Conn.get_resp_header(var!(conn), unquote(key)) do
        [value] ->
          assert value == unquote(expected_value), "Expected header '#{unquote(key)}' to equal #{unquote(expected_value)}, got #{value}"
        _ ->
          raise ExUnit.AssertionError, message: "Header not found: #{unquote(key)}"
      end
    end
  end

  defmacro assert_header_match(key, regex) do
    quote do
      case Plug.Conn.get_resp_header(var!(conn), unquote(key)) do
        [value] ->
          assert Regex.match?(unquote(regex), value)
        _ ->
          raise ExUnit.AssertionError, message: "Header not found: #{unquote(key)}"
      end
    end
  end

  defmacro assert_body(expected_body) do
    quote do
      assert var!(conn).resp_body == unquote(expected_body)
    end
  end

  defmacro assert_body_match(regex) do
    quote do
      assert Regex.match?(unquote(regex), var!(conn).resp_body)
    end
  end

end
