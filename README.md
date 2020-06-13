# to_booru

Extracts image metadata from multiple different services and converts them to a szurubooru-compatible upload format.

## Usage

``` elixir
ToBooru.extract_uploads("https://danbooru.donmai.us/posts/1") # [%ToBooru.Model.Upload{}]
```
