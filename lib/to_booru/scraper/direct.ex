defmodule ToBooru.Scraper.Direct do
  @behaviour ToBooru.Scraper

  @supported_mime_types MapSet.new([
     "image/jpeg",
     "image/bmp",
     "image/jpg",
     "image/png",
     "image/gif",
     "image/apng",
     "image/webp",
     "image/avif",
     "image/heif",
     "image/heic",
     "video/mpeg",
     "video/3gpp",
     "video/mp4",
     "video/webm",
     "application/octet-stream"
  ])

  @impl ToBooru.Scraper
  def name, do: "direct"

  @impl ToBooru.Scraper
  def infer_tags, do: true

  @impl ToBooru.Scraper
  def applies_to(uri) do
    case Tesla.client([]) |> Tesla.head(to_string(uri)) do
      {:ok, env} -> MapSet.member?(@supported_mime_types, Tesla.get_header(env, "content-type"))
      {:error, _} -> false
    end
  end

  @impl ToBooru.Scraper
  def extract_uploads(uri) do
    [
      %ToBooru.Model.Upload{
        uri: uri
      }
    ]
  end
end
