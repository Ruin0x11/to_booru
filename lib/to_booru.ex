defmodule ToBooru do
  @doc """
  Extracts images from the given URI and converts each to a
  szurubooru-compatible upload.

  """
  def extract_uploads(uri = %URI{}) do
    case ToBooru.Scraper.for_uri(uri) do
      nil -> []
      mod -> mod.extract_uploads(uri)
      |> Enum.map(fn upload -> %{upload | source: uri, tags: upload.tags ++
                                  [
                                    %ToBooru.Model.Tag{name: "imported", category: :batch},
                                    %ToBooru.Model.Tag{name: "imported:#{mod.name}", category: :batch}
                                  ]
                                } end)
    end
  end

  def extract_uploads(url) do
    ToBooru.URI.parse(url)
    |> extract_uploads
  end
end
