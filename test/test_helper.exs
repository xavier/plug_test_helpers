ExUnit.start()

defmodule AssertTestHelpers do

  defmacro assert_fail(do: block) do
    quote do
      assert_raise ExUnit.AssertionError, fn ->
        unquote(block)
      end
    end
  end

end