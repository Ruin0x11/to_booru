defmodule ToBooru.Scraper.Gelbooru.Test do
  use ToBooru.TestCase

  test "Can scrape gelbooru sites" do
    use_cassette "scraper_gelbooru", match_requests_on: [:query, :request_body] do
      results = ToBooru.URI.parse("https://gelbooru.com/index.php?page=post&s=view&id=6235985") |> ToBooru.Scraper.Gelbooru.extract_uploads
      assert Enum.count(results) == 1
      result = Enum.at(results, 0)
      expected = %{
        preview_uri: nil,
        safety: :safe,
        tags: [
          %ToBooru.Model.Tag{category: :general, name: "5girls"},
          %ToBooru.Model.Tag{category: :general, name: ":o"},
          %ToBooru.Model.Tag{category: :meta, name: "absurdres"},
          %ToBooru.Model.Tag{category: :general, name: "android"},
          %ToBooru.Model.Tag{category: :general, name: "architecture"},
          %ToBooru.Model.Tag{category: :character, name: "azki_(hololive)"},
          %ToBooru.Model.Tag{category: :general, name: "bangs"},
          %ToBooru.Model.Tag{category: :general, name: "belt"},
          %ToBooru.Model.Tag{category: :general, name: "black_dress"},
          %ToBooru.Model.Tag{category: :general, name: "black_hair"},
          %ToBooru.Model.Tag{category: :general, name: "blue_belt"},
          %ToBooru.Model.Tag{category: :general, name: "blue_bow"},
          %ToBooru.Model.Tag{category: :general, name: "blue_eyes"},
          %ToBooru.Model.Tag{category: :general, name: "blue_hair"},
          %ToBooru.Model.Tag{category: :general, name: "bow"},
          %ToBooru.Model.Tag{category: :general, name: "breasts"},
          %ToBooru.Model.Tag{category: :general, name: "brown_hair"},
          %ToBooru.Model.Tag{category: :general, name: "brown_skirt"},
          %ToBooru.Model.Tag{category: :general, name: "city"},
          %ToBooru.Model.Tag{category: :general, name: "collared_shirt"},
          %ToBooru.Model.Tag{category: :general, name: "colored_inner_hair"},
          %ToBooru.Model.Tag{category: :general, name: "dragon"},
          %ToBooru.Model.Tag{category: :general, name: "dress"},
          %ToBooru.Model.Tag{category: :general, name: "east_asian_architecture"},
          %ToBooru.Model.Tag{category: :general, name: "floating_hair"},
          %ToBooru.Model.Tag{category: :general, name: "flying"},
          %ToBooru.Model.Tag{category: :general, name: "gradient_hair"},
          %ToBooru.Model.Tag{category: :meta, name: "highres"},
          %ToBooru.Model.Tag{category: :copyright, name: "hololive"},
          %ToBooru.Model.Tag{category: :character, name: "hoshimachi_suisei"},
          %ToBooru.Model.Tag{category: :general, name: "idol"},
          %ToBooru.Model.Tag{category: :general, name: "idol_clothes"},
          %ToBooru.Model.Tag{category: :character, name: "kiryu_coco"},
          %ToBooru.Model.Tag{category: :character, name: "kiryu_coco_(dragon)"},
          %ToBooru.Model.Tag{category: :general, name: "long_hair"},
          %ToBooru.Model.Tag{category: :general, name: "looking_up"},
          %ToBooru.Model.Tag{category: :general, name: "mechanical_arms"},
          %ToBooru.Model.Tag{category: :general, name: "medium_breasts"},
          %ToBooru.Model.Tag{category: :general, name: "multicolored_hair"},
          %ToBooru.Model.Tag{category: :general, name: "multiple_girls"},
          %ToBooru.Model.Tag{category: :general, name: "pink_hair"},
          %ToBooru.Model.Tag{category: :general, name: "pink_sweater"},
          %ToBooru.Model.Tag{category: :general, name: "plaid"},
          %ToBooru.Model.Tag{category: :general, name: "plaid_dress"},
          %ToBooru.Model.Tag{category: :general, name: "red_hair"},
          %ToBooru.Model.Tag{category: :character, name: "roboco-san"},
          %ToBooru.Model.Tag{category: :character, name: "sakura_miko"},
          %ToBooru.Model.Tag{category: :general, name: "shirt"},
          %ToBooru.Model.Tag{category: :general, name: "short_hair"},
          %ToBooru.Model.Tag{category: :general, name: "side_ponytail"},
          %ToBooru.Model.Tag{category: :general, name: "skirt"},
          %ToBooru.Model.Tag{category: :general, name: "small_breasts"},
          %ToBooru.Model.Tag{category: :general, name: "smile"},
          %ToBooru.Model.Tag{category: :general, name: "sweater"},
          %ToBooru.Model.Tag{category: :character, name: "tokino_sora"},
          %ToBooru.Model.Tag{category: :general, name: "twintails"},
          %ToBooru.Model.Tag{category: :general, name: "virtual_youtuber"},
          %ToBooru.Model.Tag{category: :artist, name: "vyragami"},
          %ToBooru.Model.Tag{category: :general, name: "white_shirt"}
        ],
        uri: %URI{authority: "img3.gelbooru.com", fragment: nil, host: "img3.gelbooru.com", path: "/images/33/1d/331d39365eef04e410b1b553cbed77b7.jpg", port: 443, query: nil, scheme: "https", userinfo: nil}

      }
      Assertions.assert_maps_equal(result, expected, Map.keys(expected))
    end
  end
end
