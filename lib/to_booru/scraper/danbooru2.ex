defmodule ToBooru.Scraper.Danbooru2 do
  @behaviour ToBooru.Scraper

  @impl ToBooru.Scraper
  def name, do: "danbooru2"

  @impl ToBooru.Scraper
  def infer_tags, do: false

  defp headers(uri) do
    case ToBooru.Credentials.for_uri(uri) do
      %{username: username, password: password} ->
        with token <- Base.encode64("#{username}:#{password}") do
          [{"accept", "application/json"}, {"authorization", "Basic #{token}"}]
        end
      _ -> [{"accept", "application/json"}]
    end
  end

  def client(uri) do
    [
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, headers(uri)}
    ]
    |> Tesla.client
  end

  @impl ToBooru.Scraper
  def get_image(uri) do
    Tesla.get(client(uri), to_string(uri))
  end

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

  @impl ToBooru.Scraper
  def extract_uploads(uri) do
    with id <- extract_id(uri),
         full_uri <- Map.merge(uri, %{path: "/posts/#{id}.json"}),
         {:ok, resp} <- client(uri) |> Tesla.get(to_string(full_uri)) do
      [make_upload(resp.body)]
    end
  end
end
