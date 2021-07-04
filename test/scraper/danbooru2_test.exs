defmodule ToBooru.Scraper.Danbooru2.Test do
  use ToBooru.TestCase

  test "Can scrape Danbooru 2 sites" do
    use_cassette "scraper_danbooru_2", match_requests_on: [:query, :request_body] do
      results = ToBooru.URI.parse("https://danbooru.donmai.us/posts/472445") |> ToBooru.Scraper.Danbooru2.extract_uploads
      assert Enum.count(results) == 1
      result = Enum.at(results, 0)
      expected = %{
        preview_uri: %URI{authority: "cdn.donmai.us", fragment: nil, host: "cdn.donmai.us", path: "/preview/00/76/0076fcc3154f50f731806e50410f8f2b.jpg", port: 443, query: nil, scheme: "https", userinfo: nil},
        safety: :safe,
        tags: [
          %ToBooru.Model.Tag{category: :copyright, name: "k-on!"},
          %ToBooru.Model.Tag{category: :character, name: "kotobuki_tsumugi"},
          %ToBooru.Model.Tag{category: :artist, name: "topo_(bacchustab)"},
          %ToBooru.Model.Tag{category: :general, name: "1girl"},
          %ToBooru.Model.Tag{category: :general, name: "ass"},
          %ToBooru.Model.Tag{category: :general, name: "blonde_hair"},
          %ToBooru.Model.Tag{category: :general, name: "closed_eyes"},
          %ToBooru.Model.Tag{category: :general, name: "don't_say_\"lazy\""},
          %ToBooru.Model.Tag{category: :general, name: "dress"},
          %ToBooru.Model.Tag{category: :general, name: "drunk"},
          %ToBooru.Model.Tag{category: :general, name: "glass"},
          %ToBooru.Model.Tag{category: :general, name: "green_legwear"},
          %ToBooru.Model.Tag{category: :general, name: "hair_bun"},
          %ToBooru.Model.Tag{category: :general, name: "pantyhose"},
          %ToBooru.Model.Tag{category: :general, name: "smile"},
          %ToBooru.Model.Tag{category: :general, name: "solo"},
          %ToBooru.Model.Tag{category: :general, name: "strap_slip"},
          %ToBooru.Model.Tag{category: :general, name: "thighband_pantyhose"},
          %ToBooru.Model.Tag{category: :general, name: "upskirt"},
          %ToBooru.Model.Tag{category: :meta, name: "bad_id"},
          %ToBooru.Model.Tag{category: :meta, name: "bad_pixiv_id"},
          %ToBooru.Model.Tag{category: :meta, name: "photoshop_(medium)"}
        ],
        uri: %URI{authority: "cdn.donmai.us", fragment: nil, host: "cdn.donmai.us", path: "/original/00/76/0076fcc3154f50f731806e50410f8f2b.jpg", port: 443, query: nil, scheme: "https", userinfo: nil}
      }
      Assertions.assert_maps_equal(result, expected, Map.keys(expected))
    end
  end
end
