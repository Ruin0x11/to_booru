defmodule ToBooru.Scraper.Google do
  @behaviour ToBooru.Scraper

  @impl ToBooru.Scraper
  def name, do: "google"

  @impl ToBooru.Scraper
  def infer_tags, do: true

  @impl ToBooru.Scraper
  def applies_to(uri) do
    if uri.query != nil do
      with query <- URI.decode_query(uri.query) do
        String.match?(uri.path, ~r/\/imgres/) && query["imgurl"] != nil
      end
    else
      nil
    end
  end

  def make_uploads(raw) do
    case Regex.scan(~r/Google Image Result for ([^<]+)<\/title>/, raw) do
      [[_, url]] -> [%ToBooru.Model.Upload{
                  uri: ToBooru.URI.parse(url)
}]
      _ -> []
    end
  end

  def client do
    middleware = [
      {Tesla.Middleware.Headers, [{ "User-Agent", "Mozilla/5.0 (X11; Linux x86_64; rv:76.0) Gecko/20100101 Firefox/76.0" }]}
    ]

    Tesla.client(middleware)
  end

  @impl ToBooru.Scraper
  def extract_uploads(uri) do
    with {:ok, resp} <- client() |> Tesla.get(to_string(uri)) do
      make_uploads(resp.body)
    end
  end
end
