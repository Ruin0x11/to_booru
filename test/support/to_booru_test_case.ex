defmodule ToBooru.TestCase do
  defmacro __using__(_opts) do
    quote do
      use ExUnit.Case, async: true
      use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
      require Assertions
      doctest ToBooru

      setup_all do
        HTTPoison.start
      end

      setup do
        ExVCR.Config.filter_sensitive_data("Basic [a-z]+", "Basic ***")
        ExVCR.Config.cassette_library_dir("test/fixture/vcr_cassettes")
      end
    end
  end
end
