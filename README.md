UriTemplate
===========

[![Build Status](https://travis-ci.org/pezra/ex-uri-template.svg?branch=master)](https://travis-ci.org/pezra/ex-uri-template)
[![Module Version](https://img.shields.io/hexpm/v/uri_template.svg)](https://hex.pm/packages/uri_template)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/uri_template/)
[![Total Download](https://img.shields.io/hexpm/dt/uri_template.svg)](https://hex.pm/packages/uri_template)
[![License](https://img.shields.io/hexpm/l/uri_template.svg)](https://github.com/pezra/ex-uri-template/blob/master/LICENSE.md)
[![Last Updated](https://img.shields.io/github/last-commit/pezra/ex-uri-template.svg)](https://github.com/pezra/ex-uri-template/commits/master)


[RFC 6570](https://tools.ietf.org/html/rfc6570) compliant (level 3) URI template
processor.

## Usage

```elixir
iex> UriTemplate.expand("http://example.com/{id}", id: 42)
"http://example.com/42"

iex> tmpl = UriTemplate.from_string "http://example.com/{id}"
...> UriTemplate.expand(tmpl,  id: 42)
"http://example.com/42"
...> UriTemplate.expand(tmpl,  id: 84)
"http://example.com/84"

iex> UriTemplate.expand("http://example.com?q={terms}", terms: "fiz buzz")
"http://example.com?q=fiz%20buzz"

iex> UriTemplate.expand("http://example.com?q={terms}", terms: ["fiz", "buzz"])
"http://example.com?q=fiz,buzz"

iex> UriTemplate.expand("http://example.com?{k}", k: [one: 1, two: 2])
"http://example.com?one,1,two,2"

iex> UriTemplate.expand("http://example.com/test", id: 42)
"http://example.com/test"

iex> UriTemplate.expand("http://example.com/{lat,lng}", lat: 40, lng: -105)
"http://example.com/40,-105"

iex> UriTemplate.expand("http://example.com/{;lat,lng}", lat: 40, lng: -105)
"http://example.com/;lat=40;lng=-105"

iex> UriTemplate.expand("http://example.com/{?lat,lng}", lat: 40, lng: -105)
"http://example.com/?lat=40&lng=-105"

iex> UriTemplate.expand("http://example.com/?test{&lat,lng}", lat: 40, lng: -105)
"http://example.com/?test&lat=40&lng=-105"

iex> UriTemplate.expand("http://example.com{/lat,lng}", lat: 40, lng: -105)
"http://example.com/40/-105"

iex> UriTemplate.expand("http://example.com/test{.fmt}", fmt: "json")
"http://example.com/test.json"

iex> UriTemplate.expand("http://example.com{#lat,lng}", lat: 40, lng: -105)
"http://example.com#40,-105"

iex> UriTemplate.expand("http://example.com/{longstr:6}", longstr: "thisisquitealongstring")
"http://example.com/thisis"

```

## Installation

Add the following to your project `:deps` list:

```elixir
{:uri_template, "~>1.0"}
```

## Contributing

To run the tests:

```sh
$ mix deps.get
$ git submodule update --init
$ mix test
```

## Copyright and License

Copyright (c) 2015 Peter Williams

This work is free. You can redistribute it and/or modify it under the
terms of the MIT License. See the [LICENSE.md](./LICENSE.md) file for more details.
