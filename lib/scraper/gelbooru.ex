defmodule ToBooru.Scraper.Gelbooru do
  @behaviour ToBooru.Scraper

  @impl ToBooru.Scraper
  def name, do: "gelbooru"

  @impl ToBooru.Scraper
  def applies_to(uri) do
    if uri.query != nil do
      with query <- URI.decode_query(uri.query) do
        String.match?(uri.path, ~r/index\.php$/)
        && query["page"] == "post"
        && query["s"] == "view"
        && query["q"] == "index"
        && query["id"] != nil
      end
    else
      nil
    end
  end

  def extract_id(uri) do
    URI.decode_query(uri.query)["id"]
    |> String.to_integer
  end

  def split_tags(tag_string, category) do
    String.split(tag_string)
    |> Enum.map(fn tag -> %ToBooru.Model.Tag{name: tag, category: category} end)
  end

  def extract_rating(post) do
    case post["rating"] do
      "e" -> :unsafe
      "q" -> :questionable
      _ -> :safe
    end
  end

  def extract_tag_category(tag, uri) do
    with category <- String.to_atom(tag["type"])  do
      case category do
        :tag -> :general
        :metadata -> :meta
        _ -> category
      end
    end
  end

  def get_tag(name, uri) do
    with full_uri <- Map.merge(uri, %{path: "/index.php", query: nil}),
         {:ok, resp} <- client |> Tesla.get(to_string(full_uri), query: [{:page, "dapi"}, {:s, "tag"}, {:q, "index"}, {:json, 1}, {:name, name}]),
           tag <- List.first(resp.body) do
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
    ]

    Tesla.client(middleware)
  end

  @impl ToBooru.Scraper
  def extract_uploads(uri) do
    with id <- extract_id(uri),
         full_uri <- Map.merge(uri, %{path: "/index.php"}),
         {:ok, resp} <- client |> Tesla.get(to_string(full_uri), query: [{:page, "dapi"}, {:s, "post"}, {:q, "index"}, {:json, 1}, {:id, id}]) do
      [make_upload(List.first(resp.body), uri)]
    end
  end
end
