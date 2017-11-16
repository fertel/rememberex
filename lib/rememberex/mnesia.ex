defmodule Rememberex.Mnesia do
    def init do
      destroy()
      Application.stop(:mnesia)
      :mnesia.delete_schema([node()])
      :mnesia.create_schema([node()])
      Application.start(:mnesia)
      :mnesia.create_table(:memory_only,
        [ ram_copies: [node()],
          attributes: [:id, :field]
        ])
      :mnesia.create_table(:disc_only,
        [
          disc_only_copies: [node()],
          attributes: [:id, :field]
          ]
       )
       :mnesia.create_table(:disc_memory,
         [
           disc_copies: [node()],
           attributes: [:id, :field]
           ]
        )

    end
    def destroy do
      :mnesia.delete_table(:memory_only)
      :mnesia.delete_table(:disc_only)
      :mnesia.delete_table(:disc_memory)
    end

end
