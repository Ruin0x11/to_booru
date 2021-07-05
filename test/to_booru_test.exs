defmodule ToBooru.Test do
  use ToBooru.TestCase

  test "extract_uploads substitutes preview_uri if missing" do
    use_cassette "extract_uploads_preview_uri", match_requests_on: [:query, :request_body] do
      results = ToBooru.extract_uploads("https://gelbooru.com/index.php?page=post&s=view&id=6235985")
      assert Enum.count(results) == 1
      result = Enum.at(results, 0)
      Assertions.assert_maps_equal(result.uri, result.preview_uri, Map.keys(result.uri))
    end
  end

  test "infer_tags" do
    use_cassette "infer_tags", match_requests_on: [:query, :request_body] do
      upload = %ToBooru.Model.Upload{uri: ToBooru.URI.parse("https://www.pixiv.net/artworks/91017153"), tags: [%ToBooru.Model.Tag{category: :batch, name: "imported"}, %ToBooru.Model.Tag{category: :batch, name: "imported:pixiv"}], safety: :unknown}
      |> ToBooru.infer_tags("5f8ff510ac2967f0f5b9a5f006bc98ce")
      assert upload.safety == :safe
      assert Enum.count(upload.tags) == 41
      assert Enum.find(upload.tags, fn tag -> tag.name == "imported" && tag.category == :batch end)
      assert Enum.find(upload.tags, fn tag -> tag.name == "imported:pixiv" && tag.category == :batch end)
      assert Enum.find(upload.tags, fn tag -> tag.name == "imported:autotagged" && tag.category == :batch end)
      tag = Enum.at(upload.tags, 0)
      Assertions.assert_maps_equal(tag, %ToBooru.Model.Tag{category: :copyright, name: "hololive"}, Map.keys(tag))
    end
  end
end
