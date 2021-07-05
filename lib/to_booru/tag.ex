defmodule ToBooru.Tag do
  def tag_lookup_host, do: Application.get_env(:to_booru, :danbooru2_tag_lookup_host)

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

  defp split_tags(tag_string, category) do
    String.split(tag_string)
    |> Enum.map(fn tag -> %ToBooru.Model.Tag{name: tag, category: category} end)
  end

  def convert_danbooru2_tags(post) do
    split_tags(post["tag_string_copyright"], :copyright)
    ++ split_tags(post["tag_string_character"], :character)
    ++ split_tags(post["tag_string_artist"], :artist)
    ++ split_tags(post["tag_string_general"], :general)
    ++ split_tags(post["tag_string_meta"], :meta)
  end

  defp conv(resp) do
    case resp do
      {:ok, tags} -> tags
      {:error, _} -> nil
    end
  end

  def lookup(other_name) do
    GenServer.call(ToBooru.Tag.Cache, {:lookup, other_name}) |> conv
  end

  def lookup_artist(other_name) do
    GenServer.call(ToBooru.Tag.Cache, {:lookup_artist, other_name}) |> conv
  end

  def lookup_md5(md5) do
    GenServer.call(ToBooru.Tag.Cache, {:lookup_md5, md5}) |> conv
  end

  def clear_cache() do
    GenServer.call(ToBooru.Tag.Cache, :clear)
  end
end
