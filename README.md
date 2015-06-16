UriTemplate
===========

[![Build Status](https://travis-ci.org/pezra/ex-uri-template.svg?branch=master)](https://travis-ci.org/pezra/ex-uri-template) 
[![Hex.pm](https://img.shields.io/hexpm/v/uri_template.svg)](https://hex.pm/packages/uri_template)

[RFC 6570](https://tools.ietf.org/html/rfc6570) compliant URI template
processor. Completely supports level 3 and partially implements level 4.

Usage
----

```elixir
iex> UriTemplate.expand("http://example.com/{id}", id: 42)
"http://example.com/42"

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
```

Installation
----

Add the following to your project `:deps` list:

```elixir
{:uri_template, "~>1.0"}
```
