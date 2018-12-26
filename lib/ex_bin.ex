defmodule ExBin do
  @moduledoc """
  Documentation for ExBin.
  """

  @doc """
  Creates a stream for fetching bytes within a binary. Ideal for large
  volumes of bytes, or large binaries.

  ## Examples

      iex> ExBin.byte_stream(<<0x01, 0x02, 0x03>>) |> Enum.take(2)
      [1, 2]

  """
  def byte_stream(binary) when is_binary(binary) do
    Stream.resource(
      fn -> binary end,
      fn bin ->
        case bin do
          "" ->
            {:halt, bin}

          bin ->
            <<_>> <> acc = bin
            {[byte_at(bin, 0)], acc}
        end
      end,
      fn bin -> bin end
    )
  end

  def byte_at(<<>>, index) when index >= 0 do
    {:error, :index_out_of_bounds}
  end

  def byte_at(binary, 0) when is_binary(binary) do
    <<byte>> <> _ = binary
    byte
  end

  @doc """
  Retrives the byte at index `index` (zero-based) from `binary`.

  If the binary is empty, or already exhausted, byte_at will
  return `{:error, :index_out_of_bounds}`.
  """
  def byte_at(binary, index) when is_binary(binary) and index > 0 do
    <<_>> <> binary = binary
    byte_at(binary, index - 1)
  end

  @doc """
  Converts the given `bitstr` into a list of bits (integers).

  ## Examples:

    iex> ExBin.bits(<<0xa5, 0x93>>)
    [1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 1, 1]

  """
  def bits(bitstr) when is_bitstring(bitstr) do
    extract(bitstr, [])
  end

  defp extract(<<b::size(1), bits::bitstring>>, acc) when is_bitstring(bits) do
    extract(bits, [b | acc])
  end

  defp extract(<<>>, acc), do: acc |> Enum.reverse()

  @doc """
  Creates a stream for fetching bits from a bitstring in a lazily evaluated manner.

  ## Examples

    iex> ExBin.bit_stream(<<0xa5,0x93>>) |> Enum.take(16)
    [1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 1, 1]

  """
  def bit_stream(bitstr) when is_bitstring(bitstr) do
    Stream.resource(
      fn -> bitstr end,
      fn bin ->
        case bin do
          "" ->
            {:halt, bin}

          bin ->
            <<b::size(1), bits::bitstring>> = bin
            {[b], bits}
        end
      end,
      fn bin -> bin end
    )
  end

  def bit_at(<<>>, index) when index >= 0 do
    {:error, :index_out_of_bounds}
  end

  def bit_at(bitstr, 0) when is_bitstring(bitstr) do
    <<head::size(1), _::bitstring>> = bitstr
    head
  end

  @doc """
  Returns the bit at a specific index. If the index exceeds the length
  of the bitstring, `{:error, :index_out_of_bounds}` is returned.
  """
  def bit_at(bitstr, index) when is_bitstring(bitstr) and index > 0 do
    <<_::size(index), result::size(1), _::bitstring>> = bitstr
    result
  end
end
