defmodule Rememberex.Agent do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> %{} end)
  end
  def start do
    Agent.start(fn -> %{} end)
  end
  def put(pid, k, v) do
    Agent.update(pid, fn(m) -> Map.put(m, k, v) end)
  end
  def get(pid, k) do
    Agent.get(pid, fn(m)-> m[k] end)
  end

end
