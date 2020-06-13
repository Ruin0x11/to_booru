defmodule ScraperTest do
  use ExUnit.Case

  test "Scraper.for_uri is correct" do
    assert ToBooru.Scraper.for_uri("https://yande.re/post/show/647844") == ToBooru.Scraper.Danbooru
    assert ToBooru.Scraper.for_uri("https://danbooru.donmai.us/posts/790868?q=kotobuki_tsumugi") == ToBooru.Scraper.Danbooru2
    assert ToBooru.Scraper.for_uri("https://twitter.com/fumei_unknown/status/1264924132208041984") == ToBooru.Scraper.Twitter
    assert ToBooru.Scraper.for_uri("https://www.pixiv.net/artworks/73818152") == ToBooru.Scraper.Pixiv
    assert ToBooru.Scraper.for_uri("https://steamcdn-a.akamaihd.net/steam/apps/622220/header.jpg?t=1571845973") == ToBooru.Scraper.Direct
    assert ToBooru.Scraper.for_uri("https://gelbooru.com/index.php?page=post&s=view&q=index&id=5355456") == ToBooru.Scraper.Gelbooru
    assert ToBooru.Scraper.for_uri("https://example.com") == nil
  end
end
