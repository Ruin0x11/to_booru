defmodule ToBooru.Scraper.Direct.Test do
  use ToBooru.TestCase

  test "Can scrape direct sites" do
    use_cassette "scraper_direct", match_requests_on: [:query, :request_body] do
      results = ToBooru.URI.parse("https://upload.wikimedia.org/wikipedia/commons/e/e1/Bruck_L1400826.jpg?download") |> ToBooru.Scraper.Direct.extract_uploads
      assert Enum.count(results) == 1
      result = Enum.at(results, 0)
      expected = %{
        preview_uri: nil,
        safety: :safe,
        tags: [],
        uri: %URI{
          authority: "upload.wikimedia.org",
          fragment: nil,
          host: "upload.wikimedia.org",
          path: "/wikipedia/commons/e/e1/Bruck_L1400826.jpg",
          port: 443,
          query: "download",
          scheme: "https",
          userinfo: nil
        }
      }
      Assertions.assert_maps_equal(result, expected, Map.keys(expected))
    end
  end
end
