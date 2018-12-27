defmodule ExBin.Formatter do
  @doc """
  Pretty print a given `binary`. By default this will output
  in the same format as `hexdump <file>` from BSD general commands.
  This function returns a string, so you aren't bound to any certain
  I/O mechanism (i.e. you may not want to print this to stdout, so `IO.puts/1` is not used).

  The `opts` keyword list argument can contain the following options:
  - `:canonical` - either `true` or `false`; whether output should be in canonical format or not (`-C` flag to `hexdump` BSD command). Defaults to `true`.
  - `:start` - an integer value to start indexing at when outputting; defaults to zero.

  ## Examples

      iex> ExBin.Formatter.format_bytes(<<0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20>>, canonical: false)
      "0000000 0001 0203 0405 0607 0809 0a0b 0c0d 0e0f\\n0000010 1011 1213 14"

      iex> ExBin.Formatter.format_bytes(<<0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20>>, start: 0xa0, canonical: false)
      "00000a0 0001 0203 0405 0607 0809 0a0b 0c0d 0e0f\\n00000b0 1011 1213 14"

  ### Canonical format
  The `:canonical` option, which is the default, will produce an output as if you were running
  ```
  hexdump -C <file>
  ```

      iex> ExBin.Formatter.format_bytes("Foo:bar\\nfizz\\tbang" <> <<0xf9, 0xd4>>)
      "00000000  46 6f 6f 3a 62 61 72 0a  66 69 7a 7a 09 62 61 6e  |Foo:bar.fizz.ban|\\n00000010  67 f9 d4                                          |g..|"

  """
  def format_bytes(binary, opts \\ []) when is_binary(binary) do
    start =
      case Keyword.fetch(opts, :start) do
        {:ok, start} -> start
        :error -> 0
      end

    formatter =
      case Keyword.fetch(opts, :canonical) do
        {:ok, false} -> &format_uncanonical/2
        _ -> &format_canonical/2
      end

    binary
    |> Base.encode16(case: :lower)
    |> formatter.(start)
  end

  defp format_canonical(hex_string, start) do
    hex_string
    |> String.graphemes()
    |> Enum.chunk_every(2)
    |> Enum.map(&Enum.join/1)
    |> Enum.chunk_every(16)
    |> Enum.with_index(start)
    |> Enum.map(fn {bytes, index} ->
      index_str = String.pad_leading(Base.encode16(<<index * 16 + start>>, case: :lower), 8, "0")
      first_eight = Enum.slice(bytes, 0..7)
      last_eight = Enum.slice(bytes, 8..15)

      printable =
        bytes
        |> Enum.map(fn hex_byte ->
          {:ok, byte} = Base.decode16(hex_byte, case: :lower)

          if String.printable?(byte) do
            printable_str = String.trim(inspect(byte), "\"")

            if String.length(printable_str) == 1 do
              printable_str
            else
              "."
            end
          else
            "."
          end
        end)
        |> Enum.join()

      res_str =
        index_str <> "  " <> Enum.join(first_eight, " ") <> "  " <> Enum.join(last_eight, " ")

      String.pad_trailing(res_str, 58) <> "  |#{printable}|"
    end)
    |> Enum.join("\n")
  end

  defp format_uncanonical(hex_string, start) do
    hex_string
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
