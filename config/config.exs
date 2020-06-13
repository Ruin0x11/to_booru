import Config

config :tesla, adapter: Tesla.Adapter.Hackney

secret = Path.join(Path.dirname(__ENV__.file), "secret.exs")
if File.exists? secret do
  import_config secret
end
