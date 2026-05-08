return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",

    opts = {
      modes = {
        char = {
          enabled = false,
        },
      },
    },

    dependencies = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local function map(mode, lhs, rhs, desc)
            opts.mappings[mode] = opts.mappings[mode] or {}
            opts.mappings[mode][lhs] = { rhs, desc = desc }
          end

          -- visual mode
          map("x", "f", function() require("flash").jump() end, "Flash")
          map("x", "R", function() require("flash").treesitter_search() end, "Treesitter Search")
          map("x", "F", function() require("flash").treesitter() end, "Flash Treesitter")

          -- operator-pending mode
          map("o", "r", function() require("flash").remote() end, "Remote Flash")
          map("o", "R", function() require("flash").treesitter_search() end, "Treesitter Search")
          map("o", "f", function() require("flash").jump() end, "Flash")
          map("o", "F", function() require("flash").treesitter() end, "Flash Treesitter")

          -- normal mode
          map("n", "f", function() require("flash").jump() end, "Flash")
          map("n", "F", function() require("flash").treesitter() end, "Flash Treesitter")
        end,
      },
    },
  },
}
