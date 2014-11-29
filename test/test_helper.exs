ExUnit.start()

defmodule AssertTestHelpers do

  @doc "Passes if the given function raised an ExUnit.Assertion error"
  defmacro assert_fail(do: block) do
    quote do
      assert_raise ExUnit.AssertionError, fn ->
        unquote(block)
      end
    end
  end

  @doc "Passes if the given function raised an ExUnit.Assertion error with the given message"
  defmacro assert_fail(message, do: block) do
    quote do
      assert_raise ExUnit.AssertionError, unquote(message), fn ->
        unquote(block)
      end
    end
  end

end