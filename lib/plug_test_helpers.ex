defmodule PlugTestHelpers do

  defmacro assert_status(expected_code) when is_integer(expected_code) do
    quote do
      assert var!(conn).status == unquote(expected_code)
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

  defmacro assert_status(expected_code) when is_atom(expected_code) do
    expected_code = Dict.fetch!(@atom_to_status, expected_code)
    quote do
      assert var!(conn).status == unquote(expected_code)
    end
  end

  defmacro assert_redirect do
    quote do
      assert_status :redirect
    end
  end

  defmacro assert_redirect(url) do
    quote do
      assert_status :redirect
      location = Plug.Conn.get_resp_header(var!(conn), "location")
      assert location == [unquote(url)]
    end
  end

  defmacro assert_header(key, expected_value) do
    quote do
      case Plug.Conn.get_resp_header(var!(conn), unquote(key)) do
        [value] ->
          assert value == unquote(expected_value)
        _ ->
          raise ExUnit.AssertionError, [message: "No header \"#{unquote(key)}\""]
      end
    end
  end

  defmacro assert_header_match(key, regex) do
    quote do
      case Plug.Conn.get_resp_header(var!(conn), unquote(key)) do
        [value] ->
          assert Regex.match?(unquote(regex), value)
        _ ->
          raise ExUnit.AssertionError, [message: "No header \"#{unquote(key)}\""]
      end
    end
  end

end
