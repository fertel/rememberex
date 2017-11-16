defmodule Rememberex do
  require Record
  Record.defrecord :foo, id: nil, field: nil

  Record.defrecord :memory_only, id: nil, field: nil
  Record.defrecord :disc_only, id: nil, field: nil
  Record.defrecord :disc_memory, id: nil, field: nil


end
