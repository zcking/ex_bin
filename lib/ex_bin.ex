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
end
