return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      -- disable the separator for the source_selector winbar
      opts.source_selector.separator = { left = "", right = "" }
      -- change keymind to select source, same as buffer select
      opts.window.mappings["E"] = "prev_source"
      opts.window.mappings["R"] = "next_source"
    end,
  },
}
