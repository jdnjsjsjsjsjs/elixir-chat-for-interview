defmodule RealtimeChatTest do
  use ExUnit.Case
  doctest RealtimeChat

  test "greets the world" do
    assert RealtimeChat.hello() == :world
  end
end
