defmodule ToBooru.Scraper.Danbooru do
  @behaviour ToBooru.Scraper

  @impl ToBooru.Scraper
  def name, do: "danbooru"

  @impl ToBooru.Scraper
  def infer_tags, do: false

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

  def extract_safety(post) do
    case post["rating"] do
      "e" -> :unsafe
      "q" -> :sketchy
      _ -> :safe
    end
  end

  def get_tag(name, uri) do
    with full_uri <- Map.merge(uri, %{path: "/tag/index.json", query: nil}),
        {:ok, resp} <- client() |> Tesla.get(to_string(full_uri), query: [{:name, name}, {:limit, 0}]),
      tag <- resp.body
      |> Enum.find(fn tag -> tag["name"] == name end) do
      %ToBooru.Model.Tag{name: name, category: ToBooru.Tag.extract_tag_category(tag["type"], uri)}
    end
  end

  def make_upload(post, uri) do
    %ToBooru.Model.Upload{
      uri: ToBooru.URI.parse(post["file_url"]),
      preview_uri: ToBooru.URI.parse(post["preview_url"]),
      safety: extract_safety(post),
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

  def login_params(uri) do
    case ToBooru.Credentials.for_uri(uri) do
      %{username: username, password: password} ->
        [login: username, password_hash: :crypto.hash(:sha, password) |> Base.encode16]
      _ -> []
    end
  end

  @impl ToBooru.Scraper
  def extract_uploads(uri) do
    with id <- extract_id(uri),
         full_uri <- Map.merge(uri, %{path: "/post/index.json", query: nil}),
         {:ok, resp} <- client() |> Tesla.get(to_string(full_uri), query: [tags: "id:#{id}"] ++ login_params(uri)) do
      [make_upload(List.first(resp.body), uri)]
    end
  end
end
