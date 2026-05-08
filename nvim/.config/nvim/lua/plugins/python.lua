return {
  {
    "AstroNvim/astrolsp",
    opts = {
      servers = { "ruff", "pyright" },
      config = {
        ruff = {
          capabilities = {
            general = { positionEncodings = { "utf-16" } },
          },
          on_attach = function(client) client.server_capabilities.hoverProvider = false end,
        },
        pyright = {
          before_init = function(_, c)
            if not c.settings then c.settings = {} end
            if not c.settings.python then c.settings.python = {} end
            local root = c.root_dir or vim.fn.getcwd()
            local venv_py = root .. "/.venv/bin/python"
            c.settings.python.pythonPath = (vim.fn.filereadable(venv_py) == 1) and venv_py or vim.fn.exepath "python3"
          end,
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoImportCompletions = true,
                diagnosticSeverityOverrides = {
                  reportUnusedImport = "information",
                  reportUnusedFunction = "information",
                  reportUnusedVariable = "information",
                  reportGeneralTypeIssues = "none",
                  reportOptionalMemberAccess = "none",
                  reportOptionalSubscript = "none",
                  reportPrivateImportUsage = "none",
                },
              },
            },
          },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "python", "toml" })
      end
    end,
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    specs = {
      {
        "mfussenegger/nvim-dap-python",
        dependencies = "mfussenegger/nvim-dap",
        ft = "python",
        config = function(_, opts)
          local root = vim.fn.getcwd()
          local venv_py = root .. "/.venv/bin/python"
          local path = (vim.fn.filereadable(venv_py) == 1) and venv_py or vim.fn.exepath "python3"

          require("dap-python").setup(path, opts)

          local function strip_jsonc_comments(text)
            -- 移除 // 注释
            text = text:gsub("//[^\n]*", "")
            -- 移除 /* */ 注释
            text = text:gsub("/%*.-%*/", "")
            return text
          end

          local function read_jsonc_file(file)
            if vim.fn.filereadable(file) ~= 1 then return nil end

            local lines = vim.fn.readfile(file)
            local text = table.concat(lines, "\n")

            -- 去除 JSONC 注释
            text = strip_jsonc_comments(text)

            local ok, decoded = pcall(vim.json.decode, text)
            if not ok then return nil end

            return decoded
          end

          local function normalize_args(args)
            if type(args) ~= "table" then return nil end
            local out = {}
            for _, v in ipairs(args) do
              if type(v) == "string" then
                table.insert(out, v)
              else
                table.insert(out, tostring(v))
              end
            end
            return out
          end

          local function merge(defaults, overrides)
            local out = vim.deepcopy(defaults)
            if type(overrides) ~= "table" then return out end
            for k, v in pairs(overrides) do
              -- args 特判：确保是 string list
              if k == "args" then
                out.args = normalize_args(v) or out.args
              else
                out[k] = v
              end
            end
            return out
          end

          local function load_project_configs()
            local file = root .. "/debug_args.jsonc"
            local decoded = read_jsonc_file(file)
            if decoded == nil then return {} end

            -- 默认模板（你原来那些字段都放这里）
            local defaults = {
              type = "python",
              request = "launch",
              name = "Python: Launch (debug_args.jsonc)",
              program = "${file}",
              cwd = "${workspaceFolder}",
              console = "integratedTerminal",
              justMyCode = false,
            }

            -- 支持两种格式：顶层就是一个 config；或 { configurations=[...] }
            if type(decoded.configurations) == "table" then
              local out = {}
              for _, cfg in ipairs(decoded.configurations) do
                table.insert(out, merge(defaults, cfg))
              end
              return out
            end

            return { merge(defaults, decoded) }
          end

          local function reload_dap_python_configs()
            local dap = require "dap"
            ---@diagnostic disable-next-line: inject-field
            dap.configurations.python = dap.configurations.python or {}

            -- 先删掉之前注入的（用 name 前缀识别）
            for i = #dap.configurations.python, 1, -1 do
              local c = dap.configurations.python[i]
              if type(c) == "table" and type(c.name) == "string" and c.name:find("%(debug_args%.jsonc%)", 1, true) then
                table.remove(dap.configurations.python, i)
              end
            end

            -- 再把最新的插到最前面
            local configs = load_project_configs()
            for i = #configs, 1, -1 do
              table.insert(dap.configurations.python, 1, configs[i])
            end
          end

          vim.schedule(function()
            if vim.fn.filereadable(root .. "/debug_args.jsonc") == 1 then pcall(reload_dap_python_configs) end
          end)

          vim.api.nvim_create_autocmd("BufWritePost", {
            pattern = "debug_args.jsonc",
            callback = function() pcall(reload_dap_python_configs) end,
          })
        end,
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        python = { "ruff_organize_imports", "ruff_format" },
      },
      format_on_save = {
        lsp_format = "fallback",
      },
    },
  },
}
