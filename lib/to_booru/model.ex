defmodule ToBooru.Model.Tag do
  defstruct name: "default", category: :unknown

  @type t :: %__MODULE__{
    name: String.t(),
    category: atom()
  }
end

defmodule ToBooru.Model.Upload do
  defstruct uri: nil, preview_uri: nil, tags: [], source: nil, safety: :safe, version: 0

  @type t :: %__MODULE__{
    uri: URI.t(),
    preview_uri: URI.t(),
    tags: [ToBooru.Model.Tag.t()],
    source: URI.t(),
    safety: atom(),
    version: integer()
  }
end
