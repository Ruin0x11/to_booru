defmodule ToBooru.Tag.Cache do
  use GenServer

  defp headers(uri) do
    case ToBooru.Credentials.for_uri(uri) do
      %{username: username, password: password} ->
        with token <- Base.encode64("#{username}:#{password}") do
          [{"accept", "application/json"}, {"authorization", "Basic #{token}"}]
        end
      _ -> [{"accept", "application/json"}]
    end
  end

  defp client do
    [
      {Tesla.Middleware.BaseUrl, ToBooru.Tag.tag_lookup_host},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, headers(ToBooru.Tag.tag_lookup_host)}
    ]
    |> Tesla.client
  end

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(_) do
    {:ok, %{general: %{}, artist: %{}, source: %{}}}
  end

  defp make_tag_wiki_page(tag) do
    %ToBooru.Model.Tag{
      name: tag["title"],
      category: :unknown
    }
  end

  defp make_tag_override(tag) do
    %ToBooru.Model.Tag{
      name: tag.name,
      category: tag.category || :unknown
    }
  end

  defp make_tag_tag(tag) do
    %ToBooru.Model.Tag{
      name: tag["name"],
      category: ToBooru.Tag.extract_tag_category(tag["category"])
    }
  end

  defp make_tag_artist(tag) do
    %ToBooru.Model.Tag{
      name: tag["name"],
      category: :artist
    }
  end

  defp lookup_by_wiki_page(other_name) do
    case Tesla.get(client(), "/wiki_pages.json", query: [{:"search[other_names_match]", other_name}]) do
      {:ok, resp} ->
        fallback = resp.body |> Enum.take(1) |> Enum.map(&make_tag_wiki_page/1)
        case Enum.find(resp.body, fn x -> Enum.any?(x["other_names"], fn on -> other_name == on end) end) do
          nil -> {:ok, fallback}
          x -> case lookup_tag(x["title"]) do
                 {:ok, resp2} -> {:ok, resp2}
                 _ -> {:ok, fallback}
               end
        end
      {:error, e} -> {:error, e}
    end
  end

  defp lookup(other_name) do
    overrides = Application.get_env(:to_booru, :tag_lookup_overrides) || %{}

    case Map.get(overrides, other_name |> String.downcase) do
      nil -> lookup_by_wiki_page(other_name)
      override -> {:ok, Enum.map(override, &make_tag_override/1)}
    end
  end

  defp lookup_tag(name) do
    case Tesla.get(client(), "/tags.json", query: [{:"search[name_matches]", name}]) do
      {:ok, resp} -> {:ok, Enum.map(resp.body, &make_tag_tag/1) |> Enum.take(1)}
      {:error, e} -> {:error, e}
    end
  end

  defp lookup_artist(other_name) do
    case Tesla.get(client(), "/artists.json", query: [{:"search[any_other_name_like]", other_name}]) do
      {:ok, resp} -> {:ok, Enum.map(resp.body, &make_tag_artist/1) |> Enum.at(0)}
      {:error, e} -> {:error, e}
    end
  end

  defp lookup_md5(md5) do
    case Tesla.get(client(), "/posts.json", query: [{:tags, "md5:#{md5}"}]) do
      {:ok, resp} -> {:ok, Enum.map(resp.body, & %{
                             tags: ToBooru.Tag.convert_danbooru2_tags(&1),
                             safety: ToBooru.Scraper.Danbooru2.extract_safety(&1)
                                    })
                                    |> Enum.at(0)
                     }
      {:error, e} -> {:error, e}
    end
  end

  @impl true
  def handle_call({:lookup, name}, _from, %{general: tags} = state) do
    case Map.get(tags, name) do
      nil -> case lookup(name) do
               {:ok, tag_list} -> {:reply, {:ok, tag_list}, %{state | general: Map.put(tags, name, tag_list)}}
               {:error, e} -> {:reply, {:error, e}, state}
             end
      tag_list -> {:reply, {:ok, tag_list}, state}
    end
  end

  @impl true
  def handle_call({:lookup_artist, name}, _from, %{artist: tags} = state) do
    case Map.get(tags, name) do
      nil -> case lookup_artist(name) do
               {:ok, tag_list} -> {:reply, {:ok, tag_list}, %{state | artist: Map.put(tags, name, tag_list)}}
               {:error, e} -> {:reply, {:error, e}, state}
             end
      tag_list -> {:reply, {:ok, tag_list}, state}
    end
  end

  @impl true
  def handle_call({:lookup_md5, source}, _from, %{source: tags} = state) do
    case Map.get(tags, source) do
      nil -> case lookup_md5(source) do
               {:ok, tag_list} -> {:reply, {:ok, tag_list}, %{state | source: Map.put(tags, source, tag_list)}}
               {:error, e} -> {:reply, {:error, e}, state}
             end
      tag_list -> {:reply, {:ok, tag_list}, state}
    end
  end

  @impl true
  def handle_call(:clear, _from, _state) do
    {:reply, {:ok, nil}, %{general: %{}, artist: %{}, source: %{}}}
  end
end
