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
end
