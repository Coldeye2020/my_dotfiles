return {
  "rcarriga/nvim-dap-ui",
  dependencies = { "mfussenegger/nvim-dap" },
  opts = function(_, opts)
    local function get_layout_sizes()
      local total_lines = vim.o.lines
      local total_cols = vim.o.columns

      local bottom_height = math.max(4, math.min(12, math.floor(total_lines * 0.2)))
      local right_width = math.max(30, math.min(60, math.floor(total_cols * 0.25)))

      return {
        bottom_height = bottom_height,
        right_width = right_width,
      }
    end

    local sizes = get_layout_sizes()

    opts.layouts = {
      {
        position = "right",
        size = sizes.right_width,
        elements = {
          { id = "scopes", size = 0.35 },
          { id = "stacks", size = 0.25 },
          { id = "watches", size = 0.20 },
          { id = "breakpoints", size = 0.20 },
        },
      },
      {
        position = "bottom",
        size = sizes.bottom_height,
        elements = {
          { id = "repl", size = 0.5 },
          { id = "console", size = 0.5 },
        },
      },
    }
    return opts
  end,
  config = function(_, opts)
    require("dapui").setup(opts)

    local function count_dapui_wins()
      local count = 0
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local ft = vim.bo[buf].filetype
        if ft:match "^dapui" or ft == "dap-repl" then count = count + 1 end
      end
      return count
    end

    local function get_layout_sizes()
      local total_lines = vim.o.lines
      local total_cols = vim.o.columns
      local statusline = 3

      local bottom_height = math.max(4, math.min(12, math.floor(total_lines * 0.2)))
      local right_width = math.max(30, math.min(60, math.floor(total_cols * 0.25)))
      local available_height = total_lines - bottom_height - statusline
      local bottom_available_width = total_cols - right_width - 1

      return {
        bottom_height = bottom_height,
        right_width = right_width,
        available_height = available_height,
        bottom_available_width = bottom_available_width,
      }
    end

    local function fix_dapui_layout()
      local sizes = get_layout_sizes()
      local half_bottom_width = math.floor(sizes.bottom_available_width / 2)

      if sizes.available_height < 8 then return end

      -- 只有 dapui 完全打开时才修复布局
      if count_dapui_wins() < 6 then return end

      local wins_by_ft = {}
      local bottom_wins = {}

      for _, w in ipairs(vim.api.nvim_list_wins()) do
        local b = vim.api.nvim_win_get_buf(w)
        local ft = vim.bo[b].filetype

        if ft:match "^dapui_" then wins_by_ft[ft] = w end

        if ft == "dap-repl" or ft == "dapui_console" then table.insert(bottom_wins, { win = w, ft = ft }) end
      end

      local h_scopes = math.floor(sizes.available_height * 0.35)
      local h_stacks = math.floor(sizes.available_height * 0.25)
      local h_watches = math.floor(sizes.available_height * 0.20)
      local h_breakpoints = sizes.available_height - h_scopes - h_stacks - h_watches

      local prev_win = vim.api.nvim_get_current_win()

      for _, ft in ipairs { "dapui_scopes", "dapui_stacks", "dapui_watches", "dapui_breakpoints" } do
        local win = wins_by_ft[ft]
        if win then
          vim.fn.win_gotoid(win)
          vim.cmd("silent! vertical resize " .. sizes.right_width)
          break
        end
      end

      local heights = {
        dapui_scopes = h_scopes,
        dapui_stacks = h_stacks,
        dapui_watches = h_watches,
        dapui_breakpoints = h_breakpoints,
      }

      for _, ft in ipairs { "dapui_breakpoints", "dapui_watches", "dapui_stacks", "dapui_scopes" } do
        local win = wins_by_ft[ft]
        if win then
          vim.fn.win_gotoid(win)
          vim.cmd("silent! resize " .. heights[ft])
        end
      end

      for _, item in ipairs(bottom_wins) do
        vim.fn.win_gotoid(item.win)
        vim.cmd("silent! resize " .. sizes.bottom_height)
        vim.cmd("silent! vertical resize " .. half_bottom_width)
      end

      vim.fn.win_gotoid(prev_win)
    end

    local resize_timer = nil

    vim.api.nvim_create_autocmd("VimResized", {
      callback = function()
        if resize_timer then vim.fn.timer_stop(resize_timer) end
        resize_timer = vim.fn.timer_start(500, function()
          vim.schedule(fix_dapui_layout)
          resize_timer = nil
        end)
      end,
    })
  end,
}
