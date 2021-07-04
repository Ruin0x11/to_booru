defmodule ToBooru.Scraper.Pixiv.Test do
  use ToBooru.TestCase

  test "Can scrape Pixiv sites" do
    use_cassette "scraper_pixiv", match_requests_on: [:query] do
      results = ToBooru.URI.parse("https://www.pixiv.net/artworks/89023335") |> ToBooru.Scraper.Pixiv.extract_uploads
      assert Enum.count(results) == 1
      result = Enum.at(results, 0)
      expected = %{
        preview_uri: %URI{
          authority: "i.pximg.net",
          fragment: nil,
          host: "i.pximg.net",
          path: "/c/600x600/img-master/img/2021/04/08/23/08/41/89023335_p0_master1200.jpg",
          port: 443,
          query: nil,
          scheme: "https",
          userinfo: nil
        },
        safety: :safe,
        tags: [
          %ToBooru.Model.Tag{category: :copyright, name: "love_live!_nijigasaki_high_school_idol_club"},
          %ToBooru.Model.Tag{category: :character, name: "tennouji_rina"},
          %ToBooru.Model.Tag{category: :copyright, name: "love_live!"},
          %ToBooru.Model.Tag{category: :artist, name: "practice_student"}
        ],
        uri: %URI{
          authority: "i.pximg.net",
          fragment: nil,
          host: "i.pximg.net",
          path: "/img-original/img/2021/04/08/23/08/41/89023335_p0.png",
          port: 443,
          query: nil,
          scheme: "https",
          userinfo: nil
        }
      }
      Assertions.assert_maps_equal(result, expected, Map.keys(expected))
    end
  end

  test "Can scrape Pixiv sites (gallery)" do
    use_cassette "scraper_pixiv_gallery", match_requests_on: [:query] do
      results = ToBooru.URI.parse("https://www.pixiv.net/artworks/63226245") |> ToBooru.Scraper.Pixiv.extract_uploads
      assert Enum.count(results) == 31
      result = Enum.at(results, 0)
      expected = %{
        preview_uri: %URI{
          authority: "i.pximg.net",
          fragment: nil,
          host: "i.pximg.net",
          path: "/img-master/img/2017/06/04/23/03/36/63226245_p0_master1200.jpg",
          port: 443,
          query: nil,
          scheme: "https",
          userinfo: nil
        },
        safety: :safe,
        tags: [
          %ToBooru.Model.Tag{category: :copyright, name: "danganronpa_(series)"},
          %ToBooru.Model.Tag{category: :copyright, name: "danganronpa_2:_goodbye_despair"},
          %ToBooru.Model.Tag{category: :copyright, name: "danganronpa_v3:_killing_harmony"},
          %ToBooru.Model.Tag{category: :copyright, name: "danganronpa_3_(anime)"},
          %ToBooru.Model.Tag{category: :character, name: "harukawa_maki"},
          %ToBooru.Model.Tag{category: :character, name: "kirigiri_kyouko"},
          %ToBooru.Model.Tag{category: :character, name: "toujou_kirumi"},
          %ToBooru.Model.Tag{category: :character, name: "yumeno_himiko"},
          %ToBooru.Model.Tag{category: :character, name: "nanami_chiaki"},
          %ToBooru.Model.Tag{category: :artist, name: "nico_(nico_alice)"}
        ],
        uri: %URI{
          authority: "i.pximg.net",
          fragment: nil,
          host: "i.pximg.net",
          path: "/img-original/img/2017/06/04/23/03/36/63226245_p0.jpg",
          port: 443,
          query: nil,
          scheme: "https",
          userinfo: nil
        }
      }
      Assertions.assert_maps_equal(result, expected, Map.keys(expected))
    end
  end

  test "Can scrape Pixiv sites (ugoira)" do
    use_cassette "scraper_pixiv_ugoira", match_requests_on: [:query] do
      results = ToBooru.URI.parse("https://www.pixiv.net/artworks/90372852") |> ToBooru.Scraper.Pixiv.extract_uploads
      assert Enum.count(results) == 1
      result = Enum.at(results, 0)
      expected = %{
        preview_uri: %URI{authority: "", fragment: nil, host: "", path: "/", port: 80, query: nil, scheme: "http", userinfo: nil},
        safety: :safe,
        tags: [
          %ToBooru.Model.Tag{category: :unknown, name: "ugoira"},
          %ToBooru.Model.Tag{category: :general, name: "virtual_youtuber"},
          %ToBooru.Model.Tag{category: :character, name: "hatoba_tsugu"},
          %ToBooru.Model.Tag{category: :artist, name: "sha2mo"}
        ],
        uri: %URI{authority: "i.pximg.net", fragment: nil, host: "i.pximg.net", path: "/img-original/img/2021/06/06/20/44/59/90372852_ugoira0.png", port: 443, query: nil, scheme: "https", userinfo: nil}
      }
      Assertions.assert_maps_equal(result, expected, Map.keys(expected))
    end
  end

  test "Can scrape Pixiv sites (safety)" do
    use_cassette "scraper_pixiv_safety", match_requests_on: [:query] do
      results = ToBooru.URI.parse("https://www.pixiv.net/artworks/76612075") |> ToBooru.Scraper.Pixiv.extract_uploads
      assert Enum.count(results) == 10
      result = Enum.at(results, 0)
      expected = %{
        preview_uri: %URI{
          authority: "i.pximg.net",
          fragment: nil,
          host: "i.pximg.net",
          path: "/img-master/img/2019/09/04/00/20/54/76612075_p0_master1200.jpg",
          port: 443,
          query: nil,
          scheme: "https",
          userinfo: nil
        },
        safety: :unsafe,
        tags: [
          %ToBooru.Model.Tag{
            category: :copyright,
            name: "original"
        }
        ],
        uri: %URI{
          authority: "i.pximg.net",
          fragment: nil,
          host: "i.pximg.net",
          path: "/img-original/img/2019/09/04/00/20/54/76612075_p0.jpg",
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
