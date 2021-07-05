defmodule ToBooru.Tag.Test do
  use ToBooru.TestCase

  test "infers tags from md5" do
    use_cassette "tag_infers_tags_md5", match_requests_on: [:query, :request_body] do
      result = ToBooru.Tag.lookup_md5("5f8ff510ac2967f0f5b9a5f006bc98ce") |> IO.inspect
      assert result.safety == :safe
      assert Enum.count(result.tags) == 38
      tag = Enum.at(result.tags, 0)
      Assertions.assert_maps_equal(tag, %ToBooru.Model.Tag{category: :copyright, name: "hololive"}, Map.keys(tag))
      tag = Enum.at(result.tags, 1)
      Assertions.assert_maps_equal(tag, %ToBooru.Model.Tag{category: :character, name: "shirakami_fubuki"}, Map.keys(tag))
    end
  end
end
