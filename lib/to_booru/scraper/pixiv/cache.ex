defmodule ToBooru.Scraper.Pixiv.Cache do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> %{credentials: nil} end, name: __MODULE__)
  end

  def login do
    with %{credentials: credentials} <- Agent.get(__MODULE__, & &1) do
      case credentials do
        nil -> with username <- Application.get_env(:to_booru, :pixiv_username),
                    password <- Application.get_env(:to_booru, :pixiv_password),
                    creds <- Pixiv.Authenticator.login!(username, password) do
                      Agent.update(__MODULE__, & %{&1 | credentials: creds})
                    end
        creds -> Agent.update(__MODULE__, & %{&1 | credentials: Pixiv.Authenticator.refresh!(creds)})
      end
    end
    Agent.get(__MODULE__, & Map.get(&1, :credentials))
  end
end
