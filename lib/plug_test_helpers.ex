defmodule PlugTestHelpers do

  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
    end
  end

  defmacro assert_status(expected_status) when is_integer(expected_status) do
    quote do
      expected_status = unquote(expected_status)
      actual_status   = var!(conn).status
      assert expected_status == actual_status,
             left: expected_status,
             right: actual_status,
             message: "Expected status #{expected_status}, got #{actual_status}"
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

  defmacro assert_status(expected_status) when is_atom(expected_status) and expected_status in @status_atoms do
    expected_status = Dict.fetch!(@atom_to_status, expected_status)
    quote do
      assert_status(unquote(expected_status))
    end
  end

  defmacro assert_status(other) do
    quote do
      raise ExUnit.AssertionError, message: "Unknown status: #{inspect unquote(other)}"
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
      key = unquote(key)
      expected_value = unquote(expected_value)
      case Plug.Conn.get_resp_header(var!(conn), unquote(key)) do
        [actual_value] ->
          assert expected_value == actual_value,
                 left: expected_value,
                 right: actual_value,
                 message: "Expected header #{inspect key} to equal #{inspect expected_value}, got #{inspect actual_value}"
        _ ->
          raise ExUnit.AssertionError, message: "Header not found: #{inspect key}"
      end
    end
  end

  defmacro assert_header_match(key, regex) do
    quote do
      key = unquote(key)
      case Plug.Conn.get_resp_header(var!(conn), key) do
        [actual_value] ->
          assert Regex.match?(unquote(regex), actual_value)
        _ ->
          raise ExUnit.AssertionError, message: "Header not found: #{inspect key}"
      end
    end
  end

  defmacro assert_body(expected_body) do
    quote do
      actual_body = var!(conn).resp_body
      assert actual_body == unquote(expected_body)
    end
  end

  defmacro assert_body_match(regex) do
    quote do
      actual_body = var!(conn).resp_body
      assert Regex.match?(unquote(regex), actual_body)
    end
  end

end
