defmodule ToBooru do
  defp fix_tags(upload, mod) do
    tags = if mod.infer_tags do
      case ToBooru.Tag.lookup_source(to_string(upload.uri)) do
        [] -> case ToBooru.Tag.lookup_source(to_string(upload.source)) do
                [] -> upload.tags
                tags -> List.first(tags)
              end
          tags -> List.first(tags)
      end
    else
      upload.tags
    end

    %{upload | tags: tags ++
      [
        %ToBooru.Model.Tag{name: "imported", category: :batch},
        %ToBooru.Model.Tag{name: "imported:#{mod.name}", category: :batch}
      ]
    }
end

  defp put_if_nil(map, key, value) do
    case map do
      %{^key => nil} ->
        Map.put(map, key, value)

      %{^key => _value} ->
        map

      %{} ->
        Map.put(map, key, value)

      other ->
        :erlang.error({:badmap, other})
    end
  end

  @doc """
  Extracts images from the given URI and converts each to a
  szurubooru-compatible upload.

  """
  def extract_uploads(uri = %URI{}) do
    case ToBooru.Scraper.for_uri(uri) do
      nil -> []
      mod -> mod.extract_uploads(uri)
      |> Enum.map(fn upload -> put_if_nil(upload, :source, uri) end)
      |> Enum.map(fn upload -> put_if_nil(upload, :preview_uri, uri) end)
      |> Enum.map(& fix_tags(&1, mod))
    end
  end

  def extract_uploads(url) do
    ToBooru.URI.parse(url)
    |> extract_uploads
  end
end
