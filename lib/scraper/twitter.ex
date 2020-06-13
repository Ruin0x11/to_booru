defmodule ToBooru.Scraper.Twitter do
  @behaviour ToBooru.Scraper

  @impl ToBooru.Scraper
  def name, do: "twitter"

  @impl ToBooru.Scraper
  def applies_to(uri) do
    String.match?(uri.authority, ~r/twitter.com/)
    && length(Regex.scan(~r/\/status\/([0-9]+)/, uri.path)) == 1
  end

  def extract_id(uri) do
    Regex.scan(~r/\/status\/([0-9]+)/, uri.path)
    |> Enum.map(fn [_, i] -> i end)
    |> List.first
    |> String.to_integer
  end

  def make_upload(media, tweet) do
    %ToBooru.Model.Upload{
      uri: ToBooru.URI.parse(media.media_url_https),
      rating: if tweet.possibly_sensitive do
        :unsafe
      else
        :safe
      end
    }
  end

  @impl ToBooru.Scraper
  def extract_uploads(uri) do
    with tweet <- extract_id(uri) |> ExTwitter.show do
      tweet
      |> get_in([Access.key(:extended_entities), Access.key(:media)])
      |> Enum.map(fn media -> make_upload(media, tweet) end)
    end
  end
end
