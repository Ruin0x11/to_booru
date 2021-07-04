import Config

config :extwitter, :oauth, [
   consumer_key: "",
   consumer_secret: "",
   access_token: "",
   access_token_secret: ""
]
config :to_booru, pixiv_refresh_token: ""

config :to_booru, credentials: [
  {~r/yande\.re/, %{username: "", password: ""}},
  {~r/danbooru\.donmai\.us/, %{username: "", password: ""}}
]
