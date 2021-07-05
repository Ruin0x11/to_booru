defmodule ToBooru do
  defp add_import_tags(upload, mod) do
    %{upload | tags: upload.tags ++
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

  def infer_tags(upload, md5) do
    with extra <- %ToBooru.Model.Tag{name: "imported:autotagged", category: :batch} do
      case ToBooru.Tag.lookup_md5(md5) do
        nil -> upload
        %{tags: tags, safety: safety} -> %{upload | tags: tags ++ [extra], safety: safety}
      end
    end
  end

  @doc """
  Extracts images from the given URI and converts each to a
  szurubooru-compatible upload.
  """
  def extract_uploads(string, opts \\ [])

  def extract_uploads(uri = %URI{}, _opts) do
    case ToBooru.Scraper.for_uri(uri) do
      nil -> []
      mod -> mod.extract_uploads(uri)
      |> Enum.map(fn upload -> put_if_nil(upload, :source, uri) end)
      |> Enum.map(fn upload -> put_if_nil(upload, :preview_uri, upload.uri) end)
      |> Enum.map(fn upload -> add_import_tags(upload, mod) end)
    end
  end

  def extract_uploads(url, opts) do
    ToBooru.URI.parse(url)
    |> extract_uploads(opts)
  end
end
