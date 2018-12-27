defmodule ExBin.Formatter do
  @moduledoc false

  @doc """
  Pretty print a given `binary`. By default this will output
  in the same format as `hexdump <file>` from BSD general commands.

  ## Examples

      iex> ExBin.Formatter.format_bytes(<<0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20>>)
      "0000000 0001 0203 0405 0607 0809 0a0b 0c0d 0e0f\\n0000010 1011 1213 14"

      iex> ExBin.Formatter.format_bytes(<<0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20>>, start: 0xa0)
      "00000a0 0001 0203 0405 0607 0809 0a0b 0c0d 0e0f\\n00000b0 1011 1213 14"

  """
  def format_bytes(binary, opts \\ []) when is_binary(binary) do
    start =
      case Keyword.fetch(opts, :start) do
        {:ok, start} -> start
        :error -> 0
      end

    binary
    |> Base.encode16(case: :lower)
    |> String.graphemes()
    |> Enum.chunk_every(4)
    |> Enum.map(&Enum.join/1)
    |> Enum.chunk_every(8)
    |> Enum.with_index(start)
    |> Enum.map(fn {bytes, index} ->
      index_str = String.pad_leading(Base.encode16(<<index * 16 + start>>, case: :lower), 7, "0")

      index_str <> " " <> Enum.join(bytes, " ")
    end)
    |> Enum.join("\n")
  end
end
