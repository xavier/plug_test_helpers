defmodule PlugTestHelpersTest do
  use ExUnit.Case, async: true

  import PlugTestHelpers
  import AssertTestHelpers

  alias Plug.Conn, as: Conn

  test "assert_status 200" do
    conn = %Conn{status: 200}
    assert_status 200
    conn = %Conn{status: 0}
    assert_fail "Expected status 200, got 0" do
      assert_status 200
    end
  end

  test "assert_status :ok" do
    conn = %Conn{status: 200}
    assert_status :ok
    conn = %Conn{status: 0}
    assert_fail "Expected status 200, got 0" do
      assert_status :ok
    end
  end

  test "assert_status :bogus" do
    conn = %Conn{status: 200}
    assert_fail "Unknown status: bogus" do
      assert_status :bogus
    end
  end

  test "assert_redirect" do
    conn = Conn.put_resp_header(%Conn{status: 302}, "location", "http://example.com")
    assert_status :redirect
    assert_redirect
    assert_redirect "http://example.com"

    assert_fail "Expected header 'location' to equal http://other.com, got http://example.com" do
      assert_redirect "http://other.com"
    end

    conn = %Conn{status: 200}
    assert_fail "Expected status 302, got 200" do
      assert_redirect
    end

    conn = %Conn{status: 302}
    assert_fail "Header not found: location" do
      assert_redirect "http://example.com"
    end

    conn = Conn.put_resp_header(%Conn{status: 302}, "location", "http://example.com")
    assert_fail "Expected header 'location' to equal http://other.com, got http://example.com" do
      assert_redirect "http://other.com"
    end
  end

  test "assert_header" do
    conn = Conn.put_resp_header(%Conn{}, "content_type", "text/plain")
    assert_header "content_type", "text/plain"
    assert_fail "Header not found: bogus" do
      assert_header "bogus", "text/plain"
    end
    assert_fail do
      assert_header "content_type", "bogus"
    end
  end

  test "assert_header_match" do
    conn = Conn.put_resp_header(%Conn{}, "content_type", "text/plain")
    assert_header_match "content_type", ~r/plain/
    assert_fail do
      assert_header_match "content_type", ~r/bogus/
    end
    assert_fail do
      assert_header_match "bogus", ~r/plain/
    end
  end

  test "assert_body" do
    conn = %Conn{resp_body: "response"}
    assert_body "response"
    assert_fail do
      assert_body "other"
    end
  end

  test "assert_body_match" do
    conn = %Conn{resp_body: "response"}
    assert_body_match ~r/pon/
    assert_fail do
      assert_body_match ~r/bogus/
    end
  end
end
