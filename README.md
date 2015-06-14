UriTemplate
===========

[RFC 6570](https://tools.ietf.org/html/rfc6570) compliant URI template
processor.

Usage
----

```elixir
UriTemplate.expand("http://example.com/foo/{id}", id: 42)
# => "http://example.com/foo/42"

UriTemplate.expand("http://example.com{?foo,bar}", foo: 1, bar: 2)
# => "http://example.com?foo=1&bar=2"
```

