defmodule ToBooru.Scraper.Pixiv do
  @behaviour ToBooru.Scraper

  @impl ToBooru.Scraper
  def name, do: "pixiv"

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

  def extract_rating(resp) do
    if Enum.member?(["r18", "r18-g"], resp["age_limit"]) do
      :unsafe
    else
      :safe
    end
  end

  def make_upload(page, resp) do
    %ToBooru.Model.Upload{
      uri: ToBooru.URI.parse(page["image_urls"]["large"]),
      rating: extract_rating(resp)
    }
  end

  @impl ToBooru.Scraper
  def extract_uploads(uri) do
    with username <- Application.get_env(:to_booru, :pixiv_username),
         password <- Application.get_env(:to_booru, :pixiv_password),
           id <- extract_id(uri) do
      work = Pixiv.Authenticator.login!(username, password)
             |> Pixiv.Work.get!(id, params: [{:image_sizes, "large"}])
      if work["page_count"] > 1 && work["metadata"] do
        work["metadata"]["pages"]
        |> Enum.map(fn page -> make_upload(page, work) end)
      else
        [
          make_upload(work, work)
        ]
      end
    end
  end
end
