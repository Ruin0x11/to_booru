defmodule ToBooru.Scraper.Danbooru2 do
  @behaviour ToBooru.Scraper

  @impl ToBooru.Scraper
  def name, do: "danbooru2"

  @impl ToBooru.Scraper
  def infer_tags, do: false

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

  def extract_safety(post) do
    case post["safety"] do
      "e" -> :unsafe
      "q" -> :sketchy
      _ -> :safe
    end
  end

  def make_upload(post) do
    %ToBooru.Model.Upload{
      uri: ToBooru.URI.parse(post["file_url"]),
      preview_uri: ToBooru.URI.parse(post["preview_file_url"]),
      tags: ToBooru.Tag.convert_danbooru2_tags(post),
      safety: extract_safety(post)
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
         {:ok, resp} <- client() |> Tesla.get(to_string(full_uri)) do
      [make_upload(resp.body)]
    end
  end
end
