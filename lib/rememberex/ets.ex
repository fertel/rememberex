defmodule Rememberex.Ets do
  def init do
    try_delete([:ets, :ordered_set, :set_rc, :ordered_set_rc, :set_wc, :ordered_set_wc])
    :ets.new(:set, [:named_table, :public] )
    :ets.new(:ordered_set, [:named_table, :public, :ordered_set])
    :ets.new(:set_rc, [:named_table, :public, read_concurrency: true] )
    :ets.new(:ordered_set_rc, [:named_table, :public, :ordered_set, read_concurrency: true])
    :ets.new(:set_wc, [:named_table, :public, write_concurrency: true] )
    :ets.new(:ordered_set_wc, [:named_table, :public, :ordered_set, write_concurrency: true])
  end
  def try_delete([]), do: :ok
  def try_delete([tab | t]) do
    try do
      :ets.delete(tab)
    rescue _ ->
      :ok
    end
    try_delete(t)
  end
end
