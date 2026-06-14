---@type LazySpec
return {

  -- ── AI: Avante (Claude / Anthropic) ──────────────────────────────────────
  {
    "yetone/avante.nvim",
    opts = {
      provider = "claude",
      auto_suggestions_provider = "claude",
      claude = {
        endpoint = "https://api.anthropic.com",
        model = "claude-sonnet-4-6",
        timeout = 30000,
        temperature = 0,
        max_tokens = 8096,
      },
      behaviour = {
        auto_suggestions = false,
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = true,
      },
      windows = {
        position = "right",
        wrap = true,
        width = 35,
        sidebar_header = {
          align = "center",
          rounded = true,
        },
      },
      hints = { enabled = true },
    },
  },

  -- ── Git ──────────────────────────────────────────────────────────────────
  {
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "LazyGit", "LazyGitCurrentFile", "LazyGitConfig" },
    keys = {
      { "<Leader>gg", "<cmd>LazyGit<CR>", desc = "LazyGit" },
    },
  },

  -- ── PHP: Blade templates ──────────────────────────────────────────────────
  {
    "jwalton512/vim-blade",
    ft = { "blade" },
    config = function()
      vim.filetype.add {
        extension = { blade = "blade" },
        pattern = { [".*%.blade%.php"] = "blade" },
      }
    end,
  },

  -- ── PHP: docblock generator (<Leader>d per generare PHPDoc) ──────────────
  {
    "kkoomen/vim-doge",
    build = ":call doge#install()",
    ft = { "php", "python", "javascript", "typescript", "typescriptreact", "javascriptreact" },
    config = function()
      vim.g.doge_enable_mappings = 1
      vim.g.doge_doc_standard_php = "phpdoc"
      vim.g.doge_doc_standard_python = "google"
      vim.g.doge_doc_standard_javascript = "jsdoc"
    end,
    keys = {
      { "<Leader>dg", "<Plug>(doge-generate)", desc = "Generate docblock", ft = { "php", "python", "javascript", "typescript" } },
    },
  },

  -- ── PHP: XDebug DAP ───────────────────────────────────────────────────────
  {
    "mfussenegger/nvim-dap",
    optional = true,
    config = function()
      local dap = require "dap"

      -- PHP / XDebug via php-debug-adapter (Mason)
      dap.adapters.php = {
        type = "executable",
        command = "node",
        args = { vim.fn.stdpath "data" .. "/mason/packages/php-debug-adapter/extension/out/phpDebug.js" },
      }

      dap.configurations.php = {
        {
          name = "Listen for XDebug (Laravel / PHP)",
          type = "php",
          request = "launch",
          port = 9003,
          pathMappings = {
            ["/var/www/html"] = "${workspaceFolder}",
          },
          xdebugSettings = {
            max_data = 65535,
            show_hidden = 1,
            max_depth = 5,
          },
        },
        {
          name = "Launch PHP script",
          type = "php",
          request = "launch",
          port = 9003,
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
      }
    end,
  },

  -- ── Debug UI ──────────────────────────────────────────────────────────────
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dap, dapui = require "dap", require "dapui"
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
    end,
    keys = {
      { "<Leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
      { "<F5>",  function() require("dap").continue() end,          desc = "DAP Continue" },
      { "<F10>", function() require("dap").step_over() end,         desc = "DAP Step over" },
      { "<F11>", function() require("dap").step_into() end,         desc = "DAP Step into" },
      { "<F12>", function() require("dap").step_out() end,          desc = "DAP Step out" },
      { "<Leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      { "<Leader>dB", function() require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ") end, desc = "Conditional breakpoint" },
    },
  },

  -- ── React / Next.js: snippets JSX/TSX ─────────────────────────────────────
  {
    "dsznajder/vscode-react-javascript-snippets",
    build = "yarn install --frozen-lockfile && yarn compile",
    dependencies = { "L3MON4D3/LuaSnip" },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },

  -- ── Python: virtualenv selector ──────────────────────────────────────────
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
    ft = "python",
    config = function() require("venv-selector").setup() end,
    keys = {
      { "<Leader>cv", "<cmd>VenvSelect<CR>", desc = "Select Python venv" },
    },
  },

  -- ── LuaSnip: extend filetypes ─────────────────────────────────────────────
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      local luasnip = require "luasnip"
      -- JSX snippets in TSX
      luasnip.filetype_extend("typescript", { "javascript" })
      luasnip.filetype_extend("typescriptreact", { "javascript", "javascriptreact" })
      luasnip.filetype_extend("javascriptreact", { "javascript" })
      -- Blade eredita da PHP + HTML
      luasnip.filetype_extend("blade", { "php", "html" })
      require "astronvim.plugins.configs.luasnip"(plugin, opts)
    end,
  },

  -- ── Dashboard personalizzato ───────────────────────────────────────────────
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = table.concat({
            "  ██████╗ ███████╗██╗   ██╗",
            "  ██╔══██╗██╔════╝██║   ██║",
            "  ██║  ██║█████╗  ██║   ██║",
            "  ██║  ██║██╔══╝  ╚██╗ ██╔╝",
            "  ██████╔╝███████╗ ╚████╔╝ ",
            "  ╚═════╝ ╚══════╝  ╚═══╝  ",
            "",
            "  PHP · Python · JS · TS · Bash",
            "  Laravel · Django · React · Next",
          }, "\n"),
        },
      },
    },
  },
}
