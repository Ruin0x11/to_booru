defmodule ToBooru.Tag.Cache do
  use GenServer

  defp client do
    [
      {Tesla.Middleware.BaseUrl, ToBooru.Tag.tag_lookup_host},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{"accept", "application/json"}]}
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

  defp make_tag(tag) do
    %ToBooru.Model.Tag{
      name: tag["title"],
      category: ToBooru.Tag.extract_tag_category(tag["category_name"])
    }
  end

  defp make_tag_artist(tag) do
    %ToBooru.Model.Tag{
      name: tag["name"],
      category: :artist
    }
  end

  defp lookup(other_name) do
    case Tesla.get(client(), "/wiki_pages.json", query: [{:"search[other_names_match]", other_name}]) do
      {:ok, resp} -> {:ok, Enum.map(resp.body, &make_tag/1)}
      {:error, e} -> {:error, e}
    end
  end

  defp lookup_artist(other_name) do
    case Tesla.get(client(), "/artists.json", query: [{:"search[any_other_name_like]", other_name}]) do
      {:ok, resp} -> {:ok, Enum.map(resp.body, &make_tag_artist/1)}
      {:error, e} -> {:error, e}
    end
  end

  defp lookup_source(source) do
    case Tesla.get(client(), "/posts.json", query: [{:tags, "source:#{source}"}]) do
      {:ok, resp} -> {:ok, Enum.map(resp.body, &ToBooru.Tag.convert_danbooru2_tags/1)}
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
  def handle_call({:lookup_source, source}, _from, %{source: tags} = state) do
    case Map.get(tags, source) do
      nil -> case lookup_source(source) do
               {:ok, tag_list} -> {:reply, {:ok, tag_list}, %{state | source: Map.put(tags, source, tag_list)}}
               {:error, e} -> {:reply, {:error, e}, state}
             end
      tag_list -> {:reply, {:ok, tag_list}, state}
    end
  end
end
