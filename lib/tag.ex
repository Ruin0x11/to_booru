defmodule ToBooru.Tag do
  defp tag_lookup_host, do: Application.get_env(:to_booru, :danbooru2_tag_lookup_host)

  defp client do
    [
      {Tesla.Middleware.BaseUrl, tag_lookup_host()},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{"accept", "application/json"}]},
      Tesla.Middleware.Logger,
    ]
    |> Tesla.client
  end

  def extract_tag_category(tag_type),
    do: extract_tag_category(tag_type, URI.parse(tag_lookup_host()))

  def extract_tag_category(tag_type, uri) do
    case tag_type do
      0 -> :general
      1 -> :artist
      3 -> :copyright
      4 -> cond do
          String.match?(uri.host, ~r/sakugabooru\.com$/) -> :terminology
          true -> :character
        end
      5 -> cond do
          String.match?(uri.host, ~r/behoimi\.org$/) -> :model
          String.match?(uri.host, ~r/yande\.re$/) -> :circle
          String.match?(uri.host, ~r/sakugabooru\.com$/) -> :meta
          true -> :unknown
        end
      6 -> cond do
          String.match?(uri.host, ~r/behoimi\.org$/) -> :photo_set
          String.match?(uri.host, ~r/yande\.re$/) -> :faults
          true -> :unknown
        end
      _ -> :unknown
    end
  end

  defp make_tag(tag) do
    %ToBooru.Model.Tag{
      name: tag["title"],
      category: extract_tag_category(tag["category_name"])
    }
  end

  defp make_tag_artist(tag) do
    %ToBooru.Model.Tag{
      name: tag["name"],
      category: :artist
    }
  end

  def lookup(other_name) do
    case Tesla.get(client(), "/wiki_pages.json", query: [{:"search[other_names_match]", other_name}]) do
      {:ok, resp} -> Enum.map(resp.body, &make_tag/1)
      {:error, e} -> {:error, e}
    end
  end

  def lookup_artist(other_name) do
    case Tesla.get(client(), "/artists.json", query: [{:"search[any_other_name_like]", other_name}]) do
      {:ok, resp} -> Enum.map(resp.body, &make_tag_artist/1)
      {:error, e} -> {:error, e}
    end
  end

  defp split_tags(tag_string, category) do
    String.split(tag_string)
    |> Enum.map(fn tag -> %ToBooru.Model.Tag{name: tag, category: category} end)
  end

  def convert_danbooru2_tags(post) do
    split_tags(post["tag_string_general"], :general)
    ++ split_tags(post["tag_string_copyright"], :copyright)
    ++ split_tags(post["tag_string_character"], :character)
    ++ split_tags(post["tag_string_artist"], :artist)
    ++ split_tags(post["tag_string_meta"], :meta)
  end

  def lookup_source(source) do
    case Tesla.get(client(), "/posts.json", query: [{:tags, "source:#{source}"}]) do
      {:ok, resp} -> Enum.map(resp.body, &convert_danbooru2_tags/1)
      {:error, e} -> {:error, e}
    end
  end
end
