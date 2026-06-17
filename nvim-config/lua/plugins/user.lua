---@type LazySpec
return {

  -- ── Heirline: tab attivo giallo + statusline arricchita ─────────────────────
  {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      local status = require "astroui.status"

      -- ── Tab attivo giallo ────────────────────────────────────────────────
      vim.api.nvim_set_hl(0, "TabActiveYellow", { fg = "#1a1a1a", bg = "#f5c518", bold = true })
      local function patch(t)
        if type(t) ~= "table" then return end
        if t.surround and type(t.surround.color) == "function" then
          local orig = t.surround.color
          t.surround.color = function(self)
            if self.is_active then return "TabActiveYellow" end
            return orig(self)
          end
        end
        for _, v in pairs(t) do patch(v) end
      end
      if opts.tabline then patch(opts.tabline) end

      -- ── Disabilita winbar heirline (la sostituisce dropbar.nvim) ─────────
      opts.winbar = nil

      -- ── Statusline arricchita ────────────────────────────────────────────
      -- Aggiunge al lato destro: indentazione, encoding, line ending, file size
      local only_file = function() return vim.bo.buftype == "" end

      -- Risolve il colore fg da un gruppo highlight standard di Neovim
      local function hl_fg(group)
        local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
        local n = ok and hl.fg
        return n and string.format("#%06x", n) or nil
      end

      local dim_hl  = function() return { fg = hl_fg "Comment" } end
      local warn_hl = function() return { fg = hl_fg "DiagnosticWarn" } end

      local indent_component = {
        condition = only_file,
        provider = function()
          local t = vim.opt_local.expandtab:get() and "SP" or "TAB"
          return " " .. t .. ":" .. vim.opt_local.tabstop:get() .. " "
        end,
        hl = dim_hl,
      }

      local encoding_component = {
        condition = only_file,
        provider = function()
          local enc = (vim.bo.fileencoding ~= "" and vim.bo.fileencoding) or vim.o.encoding
          return " " .. enc:upper() .. " "
        end,
        hl = dim_hl,
      }

      local lineending_component = {
        condition = only_file,
        provider = function()
          local icons = { unix = "LF", dos = "CRLF", mac = "CR" }
          return (icons[vim.bo.fileformat] or vim.bo.fileformat) .. " "
        end,
        hl = function()
          return { fg = vim.bo.fileformat == "dos" and hl_fg "DiagnosticWarn" or hl_fg "Comment" }
        end,
      }

      local filesize_component = {
        condition = only_file,
        provider = function()
          local size = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
          if size <= 0 then return "" end
          local units = { "B", "KB", "MB" }
          local i = 1
          while size > 1024 and i < #units do size = size / 1024; i = i + 1 end
          return string.format(" %.0f%s ", size, units[i])
        end,
        hl = dim_hl,
      }

      opts.statusline = {
        hl = { fg = "fg", bg = "bg" },
        status.component.mode(),
        status.component.git_branch(),
        status.component.file_info(),
        status.component.git_diff(),
        status.component.diagnostics(),
        status.component.fill(),
        status.component.cmd_info(),
        status.component.fill(),
        indent_component,
        encoding_component,
        lineending_component,
        filesize_component,
        status.component.lsp(),
        status.component.virtual_env(),
        status.component.treesitter(),
        status.component.nav(),
        status.component.mode { surround = { separator = "right" } },
      }

      return opts
    end,
  },

  -- ── cmp-conventionalcommits: autocompletamento nei buffer gitcommit ─────────
  -- Quando apri il buffer del commit message (da lazygit, neogit, git commit)
  -- ottieni completamento automatico per tipi (feat, fix, docs…) e scope.
  {
    "davidsierradz/cmp-conventionalcommits",
    ft = "gitcommit",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      require("cmp").setup.filetype("gitcommit", {
        sources = require("cmp").config.sources {
          { name = "conventionalcommits", priority = 100 },
          { name = "buffer" },
        },
      })
    end,
  },

  -- ── kulala.nvim: REST client — esegue richieste HTTP da file .http ──────────
  --   <Leader>Rs  → esegui richiesta sotto il cursore
  --   <Leader>Ra  → esegui tutte le richieste nel file
  --   <Leader>Rn  → prossima richiesta
  --   <Leader>Rp  → richiesta precedente
  --   <Leader>Ri  → ispeziona (mostra request espansa)
  --   <Leader>Rc  → copia come cURL
  {
    "mistweaverco/kulala.nvim",
    ft = { "http", "rest" },
    opts = {
      default_env = "dev",
      display_mode = "split",
    },
    keys = {
      { "<Leader>Rs", function() require("kulala").run() end,      ft = { "http", "rest" }, desc = "HTTP send request" },
      { "<Leader>Ra", function() require("kulala").run_all() end,  ft = { "http", "rest" }, desc = "HTTP send all" },
      { "<Leader>Rn", function() require("kulala").jump_next() end, ft = { "http", "rest" }, desc = "HTTP next request" },
      { "<Leader>Rp", function() require("kulala").jump_prev() end, ft = { "http", "rest" }, desc = "HTTP prev request" },
      { "<Leader>Ri", function() require("kulala").inspect() end,  ft = { "http", "rest" }, desc = "HTTP inspect" },
      { "<Leader>Rc", function() require("kulala").copy() end,     ft = { "http", "rest" }, desc = "HTTP copy as cURL" },
    },
  },

  -- ── noice.nvim: disabilita signature LSP per evitare conflitti ─────────────
  -- `optional = true` fa sì che questo spec venga applicato solo se noice è già
  -- caricato da astrocommunity — non forza l'installazione del plugin.
  {
    "folke/noice.nvim",
    optional = true,
    opts = {
      lsp = { signature = { enabled = false } },
    },
  },

  -- ── Claude Code CLI (WebSocket MCP — context-aware: file, selezione, diff) ─
  -- Apre il terminale `claude` con piena integrazione editor:
  --   <Leader>cc  → toggle pannello Claude Code
  --   <Leader>cb  → aggiungi buffer corrente al contesto
  --   <Leader>cs  → invia selezione visuale a Claude (visual mode)
  --   <Leader>cy  → accetta diff proposto da Claude
  --   <Leader>cn  → rifiuta diff
  --   <Leader>cR  → riprendi sessione precedente (--resume)
  --   <Leader>cC  → continua conversazione (--continue)
  --   <Leader>cm  → scegli modello Claude
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    event = "VeryLazy",
    opts = {
      auto_start = true,
      track_selection = true,
      focus_after_send = false,
      terminal = {
        split_side = "right",
        split_width_percentage = 0.35,
        provider = "snacks",
        auto_close = true,
      },
      diff_opts = {
        layout = "vertical",
        auto_resize_terminal = true,
        keep_terminal_focus = false,
      },
    },
    keys = {
      { "<Leader>cc", "<cmd>ClaudeCode<cr>",            desc = "Toggle Claude Code" },
      { "<Leader>cF", "<cmd>ClaudeCodeFocus<cr>",       desc = "Focus Claude Code" },
      { "<Leader>cR", "<cmd>ClaudeCode --resume<cr>",   desc = "Resume Claude Code" },
      { "<Leader>cC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude Code" },
      { "<Leader>cm", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<Leader>cb", "<cmd>ClaudeCodeAdd %<cr>",       desc = "Add buffer to Claude" },
      { "<Leader>cs", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
      { "<Leader>cy", "<cmd>ClaudeCodeDiffAccept<cr>",  desc = "Accept Claude diff" },
      { "<Leader>cn", "<cmd>ClaudeCodeDiffDeny<cr>",    desc = "Deny Claude diff" },
    },
  },

  -- ── AI: Avante (Claude / Anthropic) ──────────────────────────────────────
  {
    "yetone/avante.nvim",
    opts = {
      provider = "claude",
      auto_suggestions_provider = "claude",
      providers = {
        claude = {
          endpoint = "https://api.anthropic.com",
          model = "claude-sonnet-4-6",
          timeout = 30000,
          extra_request_body = {
            temperature = 0,
            max_tokens  = 8096,
          },
        },
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

  -- ── Highlight occorrenze parola sotto cursore (PHP, React, tutti) ────────
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("illuminate").configure {
        providers = { "lsp", "treesitter", "regex" },
        delay = 100,
        filetypes_denylist = { "neo-tree", "lazy", "mason", "trouble" },
        under_cursor = true,
        large_file_cutoff = 2000,
      }
    end,
    keys = {
      { "]]", function() require("illuminate").goto_next_reference() end,  desc = "Next reference" },
      { "[[", function() require("illuminate").goto_prev_reference() end,  desc = "Prev reference" },
    },
  },

  -- ── Aerial: pannello funzioni/classi del file (outline) ───────────────────
  {
    "stevearc/aerial.nvim",
    keys = {
      { "<Leader>lo", "<cmd>AerialToggle<CR>",  desc = "Toggle outline (funzioni)" },
      { "<Leader>ln", "<cmd>AerialNext<CR>",    desc = "Funzione successiva" },
      { "<Leader>lp", "<cmd>AerialPrev<CR>",    desc = "Funzione precedente" },
    },
  },

  -- ── Animazione cursore fluida (enabled = true per attivare) ──────────────────
  {
    "sphamba/smear-cursor.nvim",
    enabled = false,  -- ← true/false
    event = "VeryLazy",
    opts = {
      stiffness         = 0.8,
      trailing_stiffness = 0.5,
      distance_stop_animating = 0.5,
    },
  },

  -- ── Git graph: tree dei commit con branch e diff ────────────────────────────
  -- <Leader>gl  → apre il grafico di tutti i branch
  -- <Leader>gL  → apre il grafico solo del branch corrente
  -- Nel buffer: Enter su un commit → DiffviewOpen su quel commit
  --             Selezione visuale  → DiffviewOpen sull'intervallo
  {
    "isakbm/gitgraph.nvim",
    dependencies = { "sindrets/diffview.nvim" },
    opts = {
      symbols = {
        merge_commit = "",
        commit       = "",
      },
      format = {
        timestamp = "%d/%m/%Y %H:%M",
        fields    = { "hash", "timestamp", "author", "branch_name", "tag" },
      },
      hooks = {
        on_select_commit = function(commit)
          vim.cmd("DiffviewOpen " .. commit.hash .. "^!")
        end,
        on_select_range_commit = function(from, to)
          vim.cmd("DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
        end,
      },
    },
    keys = {
      {
        "<Leader>gl",
        function() require("gitgraph").draw({}, { all = true, max_count = 2000 }) end,
        desc = "Git graph (tutti i branch)",
      },
      {
        "<Leader>gL",
        function() require("gitgraph").draw({}, { all = false, max_count = 2000 }) end,
        desc = "Git graph (branch corrente)",
      },
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

  -- ════════════════════════════════════════════════════════════════════════════
  --  UI — plugin visivi
  -- ════════════════════════════════════════════════════════════════════════════

  -- ── Breadcrumb VSCode-style nella winbar (file > Classe > metodo) ─────────
  {
    "Bekaboo/dropbar.nvim",
    event = "BufReadPost",
    opts = {
      bar = {
        update_debounce = 100,
        sources = function(buf, _)
          local sources = require "dropbar.sources"
          local utils   = require "dropbar.utils"
          if vim.bo[buf].ft == "markdown" then
            return { sources.markdown }
          end
          if vim.bo[buf].buftype == "terminal" then
            return { sources.terminal }
          end
          return {
            utils.source.fallback { sources.lsp, sources.treesitter },
          }
        end,
      },
    },
    keys = {
      { "<Leader>bp", function() require("dropbar.api").pick() end, desc = "Breadcrumb pick" },
    },
  },

  -- ── Scrollbar decorata (git, diagnostics, ricerca) ───────────────────────
  {
    "lewis6991/satellite.nvim",
    event = "BufReadPost",
    opts = {
      current_only = false,
      winblend     = 50,
      handlers = {
        cursor    = { enable = true },
        search    = { enable = true },
        diagnostic = { enable = true },
        gitsigns  = { enable = true },
        marks     = { enable = false },
      },
    },
  },

  -- ── Evidenzia il blocco di codice corrente (chunk) ────────────────────────
  {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      chunk = {
        enable    = true,
        style     = { { fg = "#f5c518" } },
        delay     = 100,
        animate   = false,  -- disabilita animazione (causa il crash nil compare)
        -- Escludi buffer senza file reale per evitare l'errore line nil
        exclude_filetypes = {
          aerial = true, ["neo-tree"] = true, lazy = true,
          mason = true, help = true, dashboard = true,
          alpha = true, TelescopePrompt = true, noice = true,
        },
      },
      indent   = { enable = false },
      line_num = { enable = false },
    },
  },

  -- ── Colori hex/rgb/hsl inline nel codice ─────────────────────────────────
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPost",
    opts = {
      filetypes = {
        "*",
        css        = { css = true },
        scss       = { css = true },
        javascript = { tailwind = true },
        typescript = { tailwind = true },
        typescriptreact = { tailwind = true },
        javascriptreact = { tailwind = true },
        html       = { tailwind = true },
      },
      user_default_options = {
        RGB      = true,
        RRGGBB   = true,
        names    = false,
        hsl_fn   = true,
        rgb_fn   = true,
        tailwind = false,
        mode     = "background",
      },
    },
  },

  -- ── Parentesi colorate per livello di annidamento ────────────────────────
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "BufReadPost",
    config = function()
      local rd = require "rainbow-delimiters"
      require("rainbow-delimiters.setup").setup {
        strategy = { [""] = rd.strategy["global"] },
        query    = { [""] = "rainbow-delimiters" },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      }
    end,
  },

  -- ── Folding LSP-aware con preview al hover ────────────────────────────────
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "BufReadPost",
    opts = {
      provider_selector = function(_, ft, _)
        local lsp_fts = { "python", "php", "javascript", "typescript",
                          "typescriptreact", "javascriptreact", "lua" }
        for _, f in ipairs(lsp_fts) do
          if ft == f then return { "lsp", "indent" } end
        end
        return { "indent" }
      end,
    },
    keys = {
      { "zR", function() require("ufo").openAllFolds() end,  desc = "Apri tutti i fold" },
      { "zM", function() require("ufo").closeAllFolds() end, desc = "Chiudi tutti i fold" },
      { "zK", function()
          local winid = require("ufo").peekFoldedLinesUnderCursor()
          if not winid then vim.lsp.buf.hover() end
        end, desc = "Preview fold / hover" },
    },
    init = function()
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
  },

  -- ── Filename galleggiante in ogni split ──────────────────────────────────
  {
    "b0o/incline.nvim",
    event = "BufReadPost",
    opts = {
      window = { margin = { vertical = 0, horizontal = 1 } },
      hide   = { cursorline = false, focused_win = false, only_win = true },
      render = function(props)
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
        if filename == "" then filename = "[No Name]" end
        local modified = vim.bo[props.buf].modified
        return {
          { filename, gui = modified and "bold,italic" or "bold" },
          modified and { " ●", guifg = "#f5c518" } or "",
        }
      end,
    },
  },

  -- ── Modalità scrittura distraction-free ──────────────────────────────────
  {
    "folke/zen-mode.nvim",
    cmd  = "ZenMode",
    opts = {
      window = { width = 0.75, options = { number = true, relativenumber = true } },
      plugins = {
        tmux      = { enabled = false },
        twilight  = { enabled = true },
      },
    },
    keys = {
      { "<Leader>uz", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },
    },
  },

  -- ── Offusca il codice fuori dal blocco corrente (usato con zen-mode) ──────
  {
    "folke/twilight.nvim",
    cmd  = { "Twilight", "TwilightEnable", "TwilightDisable" },
    opts = { dimming = { alpha = 0.25 }, context = 15 },
    keys = {
      { "<Leader>ut", "<cmd>Twilight<cr>", desc = "Toggle Twilight (dim)" },
    },
  },

  -- ── Animazioni fluide (scroll, resize, cursore) ──────────────────────────
  {
    "echasnovski/mini.animate",
    event = "VeryLazy",
    opts = {
      scroll = { enable = true },
      cursor = { enable = false },  -- già gestito da smear-cursor se attivo
      resize = { enable = true },
      open   = { enable = true },
      close  = { enable = true },
    },
  },
}
