defmodule ToBooru.Tag.Test do
  use ToBooru.TestCase, async: false

  setup do
    Application.put_env(:to_booru, :tag_lookup_overrides, %{})
    {:ok, _} = GenServer.call(ToBooru.Tag.Cache, :clear)
    :ok
  end

  test "infers tags from md5" do
    use_cassette "tag_infers_tags_md5", match_requests_on: [:query, :request_body] do
      result = ToBooru.Tag.lookup_md5("5f8ff510ac2967f0f5b9a5f006bc98ce")
      assert result.safety == :safe
      assert Enum.count(result.tags) == 38
      tag = Enum.at(result.tags, 0)
      Assertions.assert_maps_equal(tag, %ToBooru.Model.Tag{category: :copyright, name: "hololive"}, Map.keys(tag))
      tag = Enum.at(result.tags, 1)
      Assertions.assert_maps_equal(tag, %ToBooru.Model.Tag{category: :character, name: "shirakami_fubuki"}, Map.keys(tag))
    end
  end

  test "md5 not found" do
    use_cassette "tag_md5_not_found", match_requests_on: [:query, :request_body] do
      result = ToBooru.Tag.lookup_md5("dood")
      assert result == nil
    end
  end

  test "can lookup tags via danbooru2" do
   use_cassette "tag_lookup", match_requests_on: [:query, :request_body] do
      result = ToBooru.Tag.lookup("百合")

      assert result == [%ToBooru.Model.Tag{category: :general, name: "yuri"}]
    end
  end

  test "tag not found" do
    use_cassette "tag_not_found", match_requests_on: [:query, :request_body] do
      result = ToBooru.Tag.lookup("講座")

      assert result == []
    end
  end

  test "can lookup artists via danbooru2" do
   use_cassette "tag_lookup_artist", match_requests_on: [:query, :request_body] do
      result = ToBooru.Tag.lookup_artist("れぇ")

      assert result == %ToBooru.Model.Tag{category: :artist, name: "ree_(re-19)"}
    end
  end

  test "artist not found" do
   use_cassette "tag_artist_not_found", match_requests_on: [:query, :request_body] do
      result = ToBooru.Tag.lookup_artist("__dood__")

      assert result == nil
    end
  end

  test "will respect tag_lookup_overrides for tags not in danbooru2" do
    overrides = %{
      "講座" => [%{name: "drawing_tutorial", category: :meta}]
    }
    Application.put_env(:to_booru, :tag_lookup_overrides, overrides)

    use_cassette "tag_lookup_overrides", match_requests_on: [:query, :request_body] do
      result = ToBooru.Tag.lookup("講座")

      assert result == [%ToBooru.Model.Tag{category: :meta, name: "drawing_tutorial"}]
    end
  end

  test "will respect multiple tag overrides" do
    overrides = %{
      "講座" => [%{name: "drawing_tutorial", category: :meta}, %{name: "how_to", category: :meta}]
    }
    Application.put_env(:to_booru, :tag_lookup_overrides, overrides)

    use_cassette "tag_lookup_overrides_multi", match_requests_on: [:query, :request_body] do
      result = ToBooru.Tag.lookup("講座")

      assert result == [%ToBooru.Model.Tag{category: :meta, name: "drawing_tutorial"}, %ToBooru.Model.Tag{category: :meta, name: "how_to"}]
    end
  end
end
