# ContentDisposition

[Online documentation](https://hexdocs.pm/content_disposition) | [Hex.pm](https://hex.pm/packages/content_disposition)

<!-- MDOC !-->

`ContentDisposition` helps properly formatting Content-Disposition headers.

Inspired by Ruby's [`content_disposition`](https://github.com/shrinerb/content_disposition) gem,
this package formats a given disposition and optional filename to an acceptable value for the
`Content-Disposition` header. It takes care of encoding, escaping and adds an ASCII fallback.

## Examples

```elixir
# Without filename
iex> ContentDisposition.format(disposition: :inline)
"inline"

# With a filename, and disposition as a string
iex> ContentDisposition.format(disposition: "inline", filename: "kitten.jpg")
"inline; filename=\"kitten.jpg\"; filename*=UTF-8''kitten.jpg"

# With a UTF-8 filename as attachment
iex> ContentDisposition.format(disposition: :attachment, filename: "kïttéñ.jpg")
"attachment; filename=\"k%3Ftt%3F%3F.jpg\"; filename*=UTF-8''k%C3%AFtt%C3%A9%C3%B1.jpg"
```

<!-- MDOC !-->

## Installation

Add `content_disposition` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:content_disposition, "~> 1.0.0"}]
end
```

## License

This library is MIT licensed. See the
[LICENSE](https://raw.github.com/jeroenvisser101/content_disposition/main/LICENSE)
file in this repository for details.
