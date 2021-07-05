defmodule ToBooru.Scraper.Twitter.Test do
  use ToBooru.TestCase

  test "Can scrape Twitter sites" do
    use_cassette "scraper_twitter", match_requests_on: [:query, :request_body] do
      results = ToBooru.URI.parse("https://twitter.com/ma_rukan/status/1411631788733075461") |> ToBooru.Scraper.Twitter.extract_uploads
      assert Enum.count(results) == 1
      result = Enum.at(results, 0)
      expected = %{
        preview_uri: %URI{
          authority: "pbs.twimg.com",
          fragment: nil,
          host: "pbs.twimg.com",
          path: "/media/E5cfcbpVIAESpHT.jpg:small",
          port: 443,
          query: nil,
          scheme: "https",
          userinfo: nil
        },
        safety: :safe,
        tags: [],
        uri: %URI{
          authority: "pbs.twimg.com",
          fragment: nil,
          host: "pbs.twimg.com",
          path: "/media/E5cfcbpVIAESpHT.jpg:orig",
          port: 443,
          query: nil,
          scheme: "https",
          userinfo: nil
        }
      }
      Assertions.assert_maps_equal(result, expected, Map.keys(expected))
    end
  end

  test "Can scrape Twitter sites (image)" do
    use_cassette "scraper_twitter_image", match_requests_on: [:query, :request_body] do
      results = ToBooru.URI.parse("https://twitter.com/BinoOzu777/status/1411235979994669064/photo/1") |> ToBooru.Scraper.Twitter.extract_uploads
      assert Enum.count(results) == 1
      result = Enum.at(results, 0)
      expected = %{
        preview_uri: %URI{
          authority: "pbs.twimg.com",
          fragment: nil,
          host: "pbs.twimg.com",
          path: "/media/E5W3pCkUYAErxTt.jpg:small",
          port: 443,
          query: nil,
          scheme: "https",
          userinfo: nil
        },
        safety: :safe,
        tags: [],
        uri: %URI{
          authority: "pbs.twimg.com",
          fragment: nil,
          host: "pbs.twimg.com",
          path: "/media/E5W3pCkUYAErxTt.jpg:orig",
          port: 443,
          query: nil,
          scheme: "https",
          userinfo: nil
        }
      }
      Assertions.assert_maps_equal(result, expected, Map.keys(expected))
    end
  end

  test "Can scrape Twitter sites (extended)" do
    use_cassette "scraper_twitter_extended", match_requests_on: [:query, :request_body] do
      results = ToBooru.URI.parse("https://twitter.com/taktwi/status/1411323853263937537") |> ToBooru.Scraper.Twitter.extract_uploads
      assert Enum.count(results) == 4
      result = Enum.at(results, 0)
      expected = %{
        preview_uri: %URI{
          authority: "pbs.twimg.com",
          fragment: nil,
          host: "pbs.twimg.com",
          path: "/media/E5YHYalVEAcg7VY.jpg:small",
          port: 443,
          query: nil,
          scheme: "https",
          userinfo: nil
        },
        safety: :safe,
        tags: [],
        uri: %URI{
          authority: "pbs.twimg.com",
          fragment: nil,
          host: "pbs.twimg.com",
          path: "/media/E5YHYalVEAcg7VY.jpg:orig",
          port: 443,
          query: nil,
          scheme: "https",
          userinfo: nil
        }
      }
      Assertions.assert_maps_equal(result, expected, Map.keys(expected))
    end
  end

  test "Can scrape Twitter sites (safety)" do
    use_cassette "scraper_twitter_safety", match_requests_on: [:query, :request_body] do
      results = ToBooru.URI.parse("https://mobile.twitter.com/NLO28636331/status/1411515939523153920/photo/1") |> ToBooru.Scraper.Twitter.extract_uploads
      assert Enum.count(results) == 1
      result = Enum.at(results, 0)
      expected = %{
        preview_uri: %URI{
          authority: "pbs.twimg.com",
          fragment: nil,
          host: "pbs.twimg.com",
          path: "/media/E5a2O8DVkAENKMl.jpg:small",
          port: 443,
          query: nil,
          scheme: "https",
          userinfo: nil
        },
        safety: :unsafe,
        tags: [],
        uri: %URI{
          authority: "pbs.twimg.com",
          fragment: nil,
          host: "pbs.twimg.com",
          path: "/media/E5a2O8DVkAENKMl.jpg:orig",
          port: 443,
          query: nil,
          scheme: "https",
          userinfo: nil
        }
      }
      Assertions.assert_maps_equal(result, expected, Map.keys(expected))
    end
  end
end
