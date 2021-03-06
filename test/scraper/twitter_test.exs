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

  test "Can scrape Twitter sites (video)" do
    use_cassette "scraper_twitter_video", match_requests_on: [:query, :request_body] do
      results = ToBooru.URI.parse("https://twitter.com/reNPCarts/status/1411559376440250370") |> ToBooru.Scraper.Twitter.extract_uploads
      assert Enum.count(results) == 1
      result = Enum.at(results, 0)
      expected = %{
        preview_uri: %URI{
          authority: "pbs.twimg.com",
          fragment: nil,
          host: "pbs.twimg.com",
          path: "/ext_tw_video_thumb/1411558961652895745/pu/img/uia6_PnQqBX8R9rJ.jpg:small",
          port: 443,
          query: nil,
          scheme: "https",
          userinfo: nil
        },
        safety: :safe,
        tags: ["animated", "video"],
        uri: %URI{
          authority: "video.twimg.com",
          fragment: nil,
          host: "video.twimg.com",
          path: "/ext_tw_video/1411558961652895745/pu/vid/720x720/9z-IkXzbJfBoYsLi.mp4",
          port: 443,
          query: "tag=12",
          scheme: "https",
          userinfo: nil
        }
      }
      Assertions.assert_maps_equal(result, expected, Map.keys(expected))
    end
  end

  test "Can scrape Twitter sites (animated GIF)" do
    use_cassette "scraper_twitter_animated_gif", match_requests_on: [:query, :request_body] do
      results = ToBooru.URI.parse("https://twitter.com/hitoshi07140425/status/1412126934129987584") |> ToBooru.Scraper.Twitter.extract_uploads
      assert Enum.count(results) == 1
      result = Enum.at(results, 0)
      expected = %{
        preview_uri: %URI{
          authority: "pbs.twimg.com",
          fragment: nil,
          host: "pbs.twimg.com",
          path: "/tweet_video_thumb/E5jh72SVUAAUZNq.jpg:small",
          port: 443,
          query: nil,
          scheme: "https",
          userinfo: nil
        },
        tags: ["animated", "video", "animated_gif"],
        uri: %URI{
          authority: "video.twimg.com",
          fragment: nil,
          host: "video.twimg.com",
          path: "/tweet_video/E5jh72SVUAAUZNq.mp4",
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
