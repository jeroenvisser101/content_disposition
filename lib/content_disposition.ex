defmodule ContentDisposition do
  @external_resource "README.md"
  @moduledoc "README.md"
             |> File.read!()
             |> String.split("<!-- MDOC !-->")
             |> Enum.fetch!(1)

  @type disposition() :: :inline | :attachment | String.t()
  @type option() :: {:disposition, disposition()} | {:filename, String.t()}

  @rfc_5987_escaped_chars Enum.flat_map([?A..?Z, ?a..?z, ?0..?9, '!#$&+.^_`|~-'], &Enum.to_list/1)

  # NOTE: Stricly speaking, " isn't part of the reserved character set, but it should be escaped to
  # ensure it doesn't break the double-quoted string. It could be escaped as `\"`, but this works too
  @traditional_escaped_chars [?", ?\  | @rfc_5987_escaped_chars -- [?&]]

  @doc ~S"""
  Formats the given options to a standards-compliant `Content-Disposition` string.

  ## Options
    * `:disposition` - The disposition type to use.
    * `:filename` - The name of the file. This parameter is optional and when passed will be
      encoded to ASCII for the traditional field to support older browsers. Any non-ASCII
      characters (interpreted as codepoints) will be replaced with `?`, and the file name
      will be used as-is for the UTF-8 encoded filename field.

  ## Examples

      iex> ContentDisposition.format(disposition: :inline)
      "inline"

      iex> ContentDisposition.format(disposition: "inline", filename: "kitten.jpg")
      "inline; filename=\"kitten.jpg\"; filename*=UTF-8''kitten.jpg"

      iex> ContentDisposition.format(disposition: :attachment, filename: "kïttéñ.jpg")
      "attachment; filename=\"k%3Ftt%3F%3F.jpg\"; filename*=UTF-8''k%C3%AFtt%C3%A9%C3%B1.jpg"

  """
  @spec format([option()]) :: String.t()
  def format(options) do
    disposition = options |> Keyword.fetch!(:disposition) |> to_string()

    case Keyword.get(options, :filename, :without_filename) do
      :without_filename ->
        disposition

      filename when is_binary(filename) ->
        Enum.join([disposition, ascii_filename(filename), utf8_filename(filename)], "; ")
    end
  end

  @doc false
  @spec utf8_filename(String.t()) :: String.t()
  def utf8_filename(filename) do
    filename = filename |> URI.encode(&(&1 in @rfc_5987_escaped_chars))

    "filename*=UTF-8''#{filename}"
  end

  @doc false
  @spec ascii_filename(String.t()) :: String.t()
  def ascii_filename(filename) do
    filename = filename |> to_ascii() |> URI.encode(&(&1 in @traditional_escaped_chars))

    "filename=\"#{filename}\""
  end

  @ascii_codepoints Enum.map(0..127, &List.to_string([&1]))
  @spec to_ascii(String.t()) :: String.t()
  defp to_ascii(utf8) do
    for char <- String.codepoints(utf8),
        into: "",
        do: if(char in @ascii_codepoints, do: char, else: "?")
  end
end
