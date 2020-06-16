defmodule ToBooru.Credentials do
  defp all do
    Application.get_env(:to_booru, :credentials)
  end

  def for_uri(uri = %URI{}) do
    to_string(uri) |> for_uri
  end

  def for_uri(url) do
    case Enum.find(all(), fn {regex, _} -> String.match?(url, regex) end) do
      nil -> nil
      {_, creds} -> creds
    end
  end
end
