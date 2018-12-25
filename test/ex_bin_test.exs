defmodule ExBinTest do
  use ExUnit.Case
  doctest ExBin

  test "greets the world" do
    assert ExBin.hello() == :world
  end
end
