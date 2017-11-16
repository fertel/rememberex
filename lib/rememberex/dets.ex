defmodule Rememberex.Dets do
  def init do
    File.rm("dets_set")
    File.rm("dets_ordered_set")
    {:ok, set} = :dets.open_file(:dets_set, [type: :set])
    {:ok, ordered_set} = :dets.open_file(:dets_ordered_set, [type: :set])
    %{
      set: set,
      ordered_set: ordered_set
    }
  end
end
