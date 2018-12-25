defmodule ExBinTest do
  use ExUnit.Case
  doctest ExBin

  test "byte_at gets byte by index" do
    bin = <<0x1A, 0xCF, 0x24>>
    assert ExBin.byte_at(bin, 0) == 0x1A
    assert ExBin.byte_at(bin, 1) == 0xCF
    assert ExBin.byte_at(bin, 2) == 0x24
  end

  test "byte_at does not allow negative indices" do
    bin = <<0x1A>>

    assert_raise FunctionClauseError, "no function clause matching in ExBin.byte_at/2", fn ->
      ExBin.byte_at(bin, -1)
    end
  end

  test "byte_at does returns error on index out of bounds" do
    assert ExBin.byte_at("0123", 100) == {:error, :index_out_of_bounds}
  end

  test "byte_at works on really large binaries" do
    # 1,700,000 bytes
    large_binary = String.duplicate("very large binary", 100_000)

    assert to_string(<<ExBin.byte_at(large_binary, 17 * 50_000)>>) == "v"
    assert to_string(<<ExBin.byte_at(large_binary, 17 * 99_999)>>) == "v"
  end

  test "byte_stream works on large binaries" do
    # 300,000 bytes
    large_binary = String.duplicate(<<0x01, 0x02, 0x03>>, 100_000)

    bytes = ExBin.byte_stream(large_binary)
    assert Enum.take(bytes, 1) == [0x01]
    assert Enum.take(bytes, 3) == [0x01, 0x02, 0x03]

    assert Enum.take(bytes, 10) == [
             0x01,
             0x02,
             0x03,
             0x01,
             0x02,
             0x03,
             0x01,
             0x02,
             0x03,
             0x01
           ]
  end
end
