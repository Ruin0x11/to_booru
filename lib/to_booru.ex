defmodule ToBooru do
  defp add_import_tags(upload, mod) do
    %{upload | tags: upload.tags ++
      [
        %ToBooru.Model.Tag{name: "imported", category: :batch},
        %ToBooru.Model.Tag{name: "imported:#{mod.name}", category: :batch}
      ]
    }
  end

  defp infer_tags(upload) do
    with extra <- %ToBooru.Model.Tag{name: "imported:autotagged", category: :batch} do
      case ToBooru.Tag.lookup_source(to_string(upload.uri)) do
        nil -> case ToBooru.Tag.lookup_source(to_string(upload.source)) do
                 nil -> upload
                 tags -> %{upload | tags: tags ++ [extra]}
               end
        tags -> %{upload | tags: tags ++ [extra]}
      end
    end
  end

  defp infer_tags_all([first | rest] = uploads, no_infer) do
    if no_infer do
      [infer_tags(first) | rest]
    else
      Enum.map(uploads, &infer_tags/1)
    end
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
  def extract_uploads(string, opts \\ [])

  def extract_uploads(uri = %URI{}, opts) do
    with no_infer <- Keyword.get(opts, :no_infer, false) do
      case ToBooru.Scraper.for_uri(uri) do
        nil -> []
        mod -> mod.extract_uploads(uri)
        |> Enum.map(fn upload -> put_if_nil(upload, :source, uri) end)
        |> Enum.map(fn upload -> put_if_nil(upload, :preview_uri, uri) end)
        |> Enum.map(fn upload -> add_import_tags(upload, mod) end)
        |> infer_tags_all(no_infer)
      end
    end
  end

  def extract_uploads(url, opts) do
    ToBooru.URI.parse(url)
    |> extract_uploads(opts)
  end
end
