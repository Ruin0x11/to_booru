defmodule ToBooru.Scraper.Pixiv do
  @behaviour ToBooru.Scraper

  @impl ToBooru.Scraper
  def name, do: "pixiv"

  @impl ToBooru.Scraper
  def infer_tags, do: true

  @impl ToBooru.Scraper
  def applies_to(uri) do
    String.match?(uri.authority, ~r/pixiv\.net$/)
    && length(Regex.scan(~r/\/artworks\/([0-9]+)/, uri.path)) == 1
  end

  def extract_id(uri) do
    Regex.scan(~r/\/artworks\/([0-9]+)/, uri.path)
    |> Enum.map(fn [_, i] -> i end)
    |> List.first
    |> String.to_integer
  end

  def extract_safety(resp) do
    if Enum.member?(["r18", "r18-g"], resp["age_limit"]) do
      :unsafe
    else
      :safe
    end
  end

  def extract_artist_tag(resp) do
    case ToBooru.Tag.lookup_artist(resp["user"]["account"]) do
      nil -> ToBooru.Tag.lookup_artist(resp["user"]["name"])
      tag -> tag
    end
  end

  def extract_tags(resp) do
    tags = resp["tags"]
    |> Enum.map(&ToBooru.Tag.lookup/1)
    |> Enum.filter(& &1)

    case extract_artist_tag(resp) do
      nil -> tags
      artist_tag -> tags ++ [artist_tag]
    end
  end

  def make_upload(page, resp, tags) do
    %ToBooru.Model.Upload{
      uri: ToBooru.URI.parse(page["image_urls"]["large"]),
      preview_uri: ToBooru.URI.parse(page["image_urls"]["medium"]),
      safety: extract_safety(resp),
      tags: tags,
    }
  end

  @impl ToBooru.Scraper
  def extract_uploads(uri) do
    with id <- extract_id(uri) do
      work = ToBooru.Scraper.Pixiv.Cache.login
             |> Pixiv.Work.get!(id, params: [{:image_sizes, "medium,large"}])
      tags = extract_tags(work)
      if work["page_count"] > 1 && work["metadata"] do
        work["metadata"]["pages"]
        |> Enum.map(fn page -> make_upload(page, work, tags) end)
      else
        [
          make_upload(work, work, tags)
        ]
      end
    end
  end
end
