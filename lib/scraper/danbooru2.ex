defmodule ToBooru.Scraper.Danbooru2 do
  @behaviour ToBooru.Scraper

  @impl ToBooru.Scraper
  def name, do: "danbooru2"

  @impl ToBooru.Scraper
  def applies_to(uri) do
    length(Regex.scan(~r/\/posts\/([0-9]+)/, uri.path)) == 1
  end

  def extract_id(uri) do
    Regex.scan(~r/\/posts\/([0-9]+)/, uri.path)
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
      "e" -> "unsafe"
      "q" -> "questionable"
      _ -> "safe"
    end
  end

  def make_upload(post) do
    %ToBooru.Model.Upload{
      uri: ToBooru.URI.parse(post["file_url"]),
      tags: split_tags(post["tag_string_general"], "general")
      ++ split_tags(post["tag_string_copyright"], "copyright")
      ++ split_tags(post["tag_string_character"], "character")
      ++ split_tags(post["tag_string_artist"], "artist")
      ++ split_tags(post["tag_string_meta"], "meta"),
      rating: extract_rating(post)
    }
  end

  def client do
    middleware = [
      Tesla.Middleware.JSON
    ]

    Tesla.client(middleware)
  end

  @impl ToBooru.Scraper
  def extract_uploads(uri) do
    with id <- extract_id(uri),
         full_uri <- Map.merge(uri, %{path: "/posts/#{id}.json"}),
         {:ok, resp} <- client |> Tesla.get(to_string(full_uri)) do
      [make_upload(resp.body)]
    end
  end
end
