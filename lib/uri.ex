defmodule ToBooru.URI do
  def parse(uri) when is_binary(uri), do: parse(URI.parse(uri))
  def parse(uri = %URI{scheme: nil}), do: parse("http://#{to_string(uri)}")
  def parse(uri = %URI{path: nil}), do: parse("#{to_string(uri)}/")
  def parse(uri), do: uri
end
