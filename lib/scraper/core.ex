defmodule ToBooru.Scraper do
  @callback name :: String.t
  @callback applies_to(URI.t) :: boolean
  @callback extract_uploads(URI.t) :: {:ok, [ToBooru.Model.Upload.t]} | {:error, String.t}

  def all do
    with {:ok, list} <- :application.get_key(:to_booru, :modules) do
      list
      |> Enum.filter(& &1 |> Module.split |> Enum.take(2) == ~w|ToBooru Scraper|)
      |> Enum.filter(& &1 != ToBooru.Scraper)
    end
  end

  def for_uri(uri = %URI{}) do
    ToBooru.Scraper.all |> Enum.find(fn m -> m.applies_to(uri) end)
  end

  def for_uri(uri) do
    ToBooru.URI.parse(uri)
    |> for_uri
  end
end
