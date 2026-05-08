return {
  {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      opts.mappings.n["R"] = {
        function() require("astrocore.buffer").nav(vim.v.count1) end,
        desc = "Next buffer",
      }
      opts.mappings.n["E"] = {
        function() require("astrocore.buffer").nav(-vim.v.count1) end,
        desc = "Previous buffer",
      }
      opts.mappings.n["X"] = {
        function() require("astrocore.buffer").close() end,
        desc = "Close buffer",
      }
      opts.mappings.n["<Leader>dr"] = {
        function() require("dap").restart() end,
        desc = "DAP: Restart session",
      }
    end,
  },
}
