defmodule ToBooru.Scraper.Danbooru do
  @behaviour ToBooru.Scraper

  @impl ToBooru.Scraper
  def name, do: "danbooru"

  @impl ToBooru.Scraper
  def applies_to(uri) do
    length(Regex.scan(~r/\/post\/show\/([0-9]+)/, uri.path)) == 1
  end

  def extract_id(uri) do
    Regex.scan(~r/\/post\/show\/([0-9]+)/, uri.path)
    |> Enum.map(fn [_, i] -> i end)
    |> List.first
    |> String.to_integer
  end

  def split_tags(tag_string, category) do
    String.split(tag_string)
    |> Enum.map(fn tag -> %ToBooru.Model.Tag{name: tag, category: category} end)
  end

  def extract_rating(post) do
    case post["safety"] do
      "e" -> :unsafe
      "q" -> :questionable
      _ -> :safe
    end
  end

  def extract_tag_category(tag, uri) do
    case tag["type"] do
      0 -> :general
      1 -> :artist
      3 -> :copyright
      4 -> cond do
          String.match?(uri.host, ~r/sakugabooru\.com$/) -> :terminology
          true -> :character
        end
      5 -> cond do
          String.match?(uri.host, ~r/behoimi\.org$/) -> :model
          String.match?(uri.host, ~r/yande\.re$/) -> :circle
          String.match?(uri.host, ~r/sakugabooru\.com$/) -> :meta
          true -> :unknown
        end
      6 -> cond do
          String.match?(uri.host, ~r/behoimi\.org$/) -> :photo_set
          String.match?(uri.host, ~r/yande\.re$/) -> :faults
          true -> :unknown
        end
      _ -> :unknown
    end
  end

  def get_tag(name, uri) do
    with full_uri <- Map.merge(uri, %{path: "/tag/index.json"}),
        {:ok, resp} <- client |> Tesla.get(to_string(full_uri), query: [{:name, name}, {:limit, 0}]),
      tag <- resp.body
      |> Enum.find(fn tag -> tag["name"] == name end) do
      %ToBooru.Model.Tag{name: name, category: extract_tag_category(tag, uri)}
    end
  end

  def make_upload(post, uri) do
    %ToBooru.Model.Upload{
      uri: ToBooru.URI.parse(post["file_url"]),
      rating: extract_rating(post),
      tags: String.split(post["tags"]) |> Enum.map(fn tag -> get_tag(tag, uri) end)
    }
  end

  def client do
    middleware = [
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{ "User-Agent", "Mozilla/5.0 (X11; Linux x86_64; rv:76.0) Gecko/20100101 Firefox/76.0" }]}
    ]

    Tesla.client(middleware)
  end

  @impl ToBooru.Scraper
  def extract_uploads(uri) do
    with id <- extract_id(uri),
         full_uri <- Map.merge(uri, %{path: "/post/index.json"}),
         {:ok, resp} <- client |> Tesla.get(to_string(full_uri), query: [{:tags, "id:#{id}"}]) do
      [make_upload(List.first(resp.body), uri)]
    end
  end
end
