defmodule ToBooru.Tag.Cache.Test do
  use ToBooru.TestCase, async: false

  setup do
    Application.put_env(:to_booru, :tag_lookup_overrides, %{})
    {:ok, _} = GenServer.call(ToBooru.Tag.Cache, :clear)
    :ok
  end

  test "can lookup tags via danbooru2" do
    use_cassette "tag_cache_lookup", match_requests_on: [:query, :request_body] do
      result = GenServer.call(ToBooru.Tag.Cache, {:lookup, "百合"})

      assert result == {:ok, [%ToBooru.Model.Tag{category: :general, name: "yuri"}]}
    end
  end

  test "tag not found" do
    use_cassette "tag_cache_not_found", match_requests_on: [:query, :request_body] do
      result = GenServer.call(ToBooru.Tag.Cache, {:lookup, "講座"})

      assert result == {:ok, []}
    end
  end

  test "will respect tag_lookup_overrides for tags not in danbooru2" do
    overrides = %{
      "講座" => [%{name: "drawing_tutorial", category: :meta}]
    }
    Application.put_env(:to_booru, :tag_lookup_overrides, overrides)

    use_cassette "tag_cache_lookup_overrides", match_requests_on: [:query, :request_body] do
      result = GenServer.call(ToBooru.Tag.Cache, {:lookup, "講座"})

      assert result == {:ok, [%ToBooru.Model.Tag{category: :meta, name: "drawing_tutorial"}]}
    end
  end
end
