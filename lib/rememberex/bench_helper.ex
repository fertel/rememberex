defmodule Rememberex.BenchHelper do
  alias Rememberex.{Ets, Dets, Mnesia}
  alias Rememberex.Agent, as: RemAgent
  require Rememberex

  def read_bench(parallel) do
    Ets.init
    %{set: dets_set,
      ordered_set: dets_ordered_set} = Dets.init
    Mnesia.init
    {:ok, agent_with_keys} = RemAgent.start()
    map = Enum.map(1..100_000, fn (i)->
      RemAgent.put(agent_with_keys, i, i)
      :ets.insert(:set, {i, i})
      :ets.insert(:ordered_set, {i, i})
      :ets.insert(:set_rc, {i, i})
      :ets.insert(:ordered_set_rc, {i, i})
      :dets.insert(dets_set, {i, i})
      :dets.insert(dets_ordered_set, {i, i})
      :mnesia.dirty_write(Rememberex.memory_only(id: i, field: i))
      :mnesia.dirty_write(Rememberex.disc_only(id: i, field: i))
      :mnesia.dirty_write(Rememberex.disc_memory(id: i, field: i))
      {i,i}
    end) |> Enum.into(%{})
    Benchee.run(
    %{
      "ets set lookup" => fn(k) -> :ets.lookup(:set, k) end,
      "ets ordered set lookup" => fn(k) -> :ets.lookup(:ordered_set, k) end,
      "ets set lookup rc" => fn(k) -> :ets.lookup(:set_rc, k) end,
      "ets ordered set lookup rc"=> fn(k) -> :ets.lookup(:ordered_set_rc, k) end,
      "dets set lookup" => fn(k) -> :dets.lookup(dets_set, k) end,
      "dets ordered set lookup" => fn(k) -> :dets.lookup(dets_ordered_set, k) end,
      "map lookup"  => fn(k) -> Map.get(map, k) end,
      "agent lookup" => fn(k) -> RemAgent.get(agent_with_keys, k) end,
      "mnesia dirty read memory only" => fn(k) -> :mnesia.dirty_read({:memory_only, k}) end,
      "mnesia dirty read disc only" => fn(k) ->  :mnesia.dirty_read({:disc_only, k}) end ,
      "mnesia dirty read disc copies" => fn(k) -> :mnesia.dirty_read({:disc_memory, k}) end,
      "mnesia transaction read memory only" => fn(k) -> tran_read(:memory_only, k) end,
      "mnesia transaction read disc only" => fn(k) -> tran_read(:disc_only, k) end,
      "mnesia transaction read disc copies" => fn(k) -> tran_read(:disc_memory, k) end,
    }, time: 10,
        print: %{fast_warning: false},
        parallel: parallel,
        before_each: &random_number/1,
        formatters: [
         Benchee.Formatters.CSV,
         Benchee.Formatters.Console
       ]
      )
  end
  def write_bench(parallel) do
    Ets.init
    %{set: dets_set,
      ordered_set: dets_ordered_set} = Dets.init
    Mnesia.init
    {:ok, agent} = RemAgent.start()
    map = %{} #this is dumb here not growing in size
    Benchee.run(
    %{
      "ets set insert" => fn(k) -> :ets.insert(:set, {k,k}) end,
      "ets ordered set insert" => fn(k) -> :ets.insert(:ordered_set, {k, k}) end,
      "ets set insert wc" => fn(k) -> :ets.insert(:set_wc, {k, k}) end,
      "ets ordered set insert wc"=> fn(k) -> :ets.insert(:ordered_set_wc, {k, k}) end,
      "dets set insert" => fn(k) -> :dets.insert(dets_set, {k, k}) end,
      "dets ordered insert" => fn(k) -> :dets.insert(dets_ordered_set, {k, k}) end,
      "map put"  => fn(k) -> Map.put(map, k, k) end,
      "agent put" => fn(k) -> RemAgent.put(agent, k, k) end,
      "mnesia dirty write memory only" => fn(k) -> :mnesia.dirty_write({:memory_only, k, k}) end,
      "mnesia dirty write disc only" => fn(k) ->  :mnesia.dirty_write({:disc_only, k, k}) end ,
      "mnesia dirty write disc copies" => fn(k) -> :mnesia.dirty_write({:disc_memory, k, k}) end,
      "mnesia transaction write memory only" => fn(k) -> tran_write(:memory_only, k) end,
      "mnesia transaction write  disc only" => fn(k) -> tran_write(:disc_only, k) end,
      "mnesia transaction write disc copies" => fn(k) -> tran_write(:disc_memory, k) end,
    }, time: 10,
        print: %{fast_warning: false},
        parallel: parallel,
        before_each: &random_number/1,
        formatters: [
         Benchee.Formatters.CSV,
         Benchee.Formatters.Console
       ]
      )



  end

  defp tran_read(table, key) do
    :mnesia.transaction(fn ->
      :mnesia.read({table, key})
    end)
  end
  defp tran_write(table, key) do
    :mnesia.transaction(fn ->
      :mnesia.write({table, key, key})
    end)
  end

  defp random_number(_), do: :rand.uniform(100_000)



end
