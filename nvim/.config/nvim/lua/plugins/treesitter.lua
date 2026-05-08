return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.highlight = opts.highlight or {}
      opts.highlight.disable = vim.list_extend(opts.highlight.disable or {}, { "csv" })
    end,
  },
}
