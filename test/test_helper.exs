Code.eval_file "test/secrets.exs"
ExVCR.Config.cassette_library_dir("test/fixture/vcr_cassettes")
ExUnit.start()
