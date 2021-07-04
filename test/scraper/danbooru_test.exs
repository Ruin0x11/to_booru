defmodule ToBooru.Scraper.Danbooru.Test do
  use ExUnit.Case, async: true
  use ExVCR.Mock
  require Assertions

  test "Can scrape Danbooru 1 sites" do
    use_cassette "scraper_danbooru" do
      results = ToBooru.URI.parse("https://yande.re/post/show/760737") |> ToBooru.Scraper.Danbooru.extract_uploads
      assert Enum.count(results) == 1
      result = Enum.at(results, 0)
      expected = %{
        preview_uri: %URI{
          authority: "assets.yande.re",
          fragment: nil,
          host: "assets.yande.re",
          path: "/data/preview/7d/57/7d572e676dcc9353bd2173a8f6126735.jpg",
          port: 443,
          query: nil,
          scheme: "https",
          userinfo: nil
        },
        tags: [
          %ToBooru.Model.Tag{category: :artist, name: "hasisisissy"},
          %ToBooru.Model.Tag{category: :copyright, name: "hibike!_euphonium"},
          %ToBooru.Model.Tag{category: :character, name: "kasaki_nozomi"},
          %ToBooru.Model.Tag{category: :copyright, name: "liz_to_aoi_tori"},
          %ToBooru.Model.Tag{category: :general, name: "seifuku"},
          %ToBooru.Model.Tag{category: :character, name: "yoroizuka_mizore"}
        ],
        safety: :safe,
        uri: %URI{
          authority: "files.yande.re",
          fragment: nil,
          host: "files.yande.re",
          path: "/image/7d572e676dcc9353bd2173a8f6126735/yande.re%20760737%20hasisisissy%20hibike%21_euphonium%20kasaki_nozomi%20liz_to_aoi_tori%20seifuku%20yoroizuka_mizore.jpg",
          port: 443,
          query: nil,
          scheme: "https",
          userinfo: nil
        }
      }
      Assertions.assert_maps_equal(result, expected, Map.keys(expected))
    end
  end

  test "Can scrape Danbooru 1 sites (rating)" do
    use_cassette "scraper_danbooru_rating" do
      results = ToBooru.URI.parse("https://yande.re/post/show/60948") |> ToBooru.Scraper.Danbooru.extract_uploads
      assert Enum.count(results) == 1
      result = Enum.at(results, 0)
      expected = %ToBooru.Model.Upload{
        preview_uri: %URI{
          authority: "assets.yande.re",
          fragment: nil,
          host: "assets.yande.re",
          path: "/data/preview/7c/e5/7ce53ce0d81b77bc5ad857280e778857.jpg",
          port: 443,
          query: nil,
          scheme: "https",
          userinfo: nil
        },
        safety: :unsafe,
        source: nil,
        tags: [
          %ToBooru.Model.Tag{category: :general, name: "loli"},
          %ToBooru.Model.Tag{category: :artist, name: "sasahara_yuuki"}
        ],
        uri: %URI{
          authority: "files.yande.re",
          fragment: nil,
          host: "files.yande.re",
          path: "/image/7ce53ce0d81b77bc5ad857280e778857/yande.re%2060948%20loli%20sasahara_yuuki.png",
          port: 443,
          query: nil,
          scheme: "https",
          userinfo: nil
        },
        version: 0
      }
      Assertions.assert_maps_equal(result, expected, Map.keys(expected))
    end
  end

  test "Can scrape Danbooru 1 sites (tag categories)" do
    use_cassette "scraper_danbooru_tag_categories" do
      results = ToBooru.URI.parse("https://yande.re/post/show/468894") |> ToBooru.Scraper.Danbooru.extract_uploads
      assert Enum.count(results) == 1
      result = Enum.at(results, 0)
      expected = %ToBooru.Model.Upload{
        preview_uri: %URI{
          authority: "assets.yande.re",
          fragment: nil,
          host: "assets.yande.re",
          path: "/data/preview/09/17/09179bb3e9e8f451af67247eaa93008b.jpg",
          port: 443,
          query: nil,
          scheme: "https",
          userinfo: nil
        },
        safety: :sketchy,
        tags: [
          %ToBooru.Model.Tag{category: :general, name: "armor"},
          %ToBooru.Model.Tag{category: :faults, name: "cropme"},
          %ToBooru.Model.Tag{category: :copyright, name: "fire_emblem"},
          %ToBooru.Model.Tag{category: :copyright, name: "fire_emblem_heroes"},
          %ToBooru.Model.Tag{category: :copyright, name: "fire_emblem_kakusei"},
          %ToBooru.Model.Tag{category: :circle, name: "nintendo"},
          %ToBooru.Model.Tag{category: :artist, name: "pikomaro"},
          %ToBooru.Model.Tag{category: :general, name: "stockings"},
          %ToBooru.Model.Tag{category: :character, name: "sumia"},
          %ToBooru.Model.Tag{category: :general, name: "thighhighs"}
        ],
        uri: %URI{
          authority: "files.yande.re",
          fragment: nil,
          host: "files.yande.re",
          path: "/image/09179bb3e9e8f451af67247eaa93008b/yande.re%20468894%20armor%20cropme%20fire_emblem%20fire_emblem_heroes%20fire_emblem_kakusei%20nintendo%20pikomaro%20stockings%20sumia%20thighhighs.jpg",
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
