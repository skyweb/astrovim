---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 },
      autopairs = true,
      cmp = true,
      diagnostics = { virtual_text = true, virtual_lines = false },
      highlighturl = true,
      notifications = true,
    },
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    filetypes = {
      extension = {
        blade = "blade",
        env = "sh",
      },
      filename = {
        [".env.example"] = "sh",
        ["Dockerfile"] = "dockerfile",
      },
      pattern = {
        [".*%.blade%.php"] = "blade",
        [".*/%.github/workflows/.*%.ya?ml"] = "yaml.ghactions",
      },
    },
    options = {
      opt = {
        relativenumber = true,
        number = true,
        spell = false,
        signcolumn = "yes",
        wrap = false,
        tabstop = 4,
        shiftwidth = 4,
        softtabstop = 4,
        expandtab = true,
        smartindent = true,
        scrolloff = 8,
        sidescrolloff = 8,
        cursorline = true,
        termguicolors = true,
        -- splits
        splitright = true,
        splitbelow = true,
        -- search
        ignorecase = true,
        smartcase = true,
      },
      g = {},
    },
    mappings = {
      n = {
        -- ── Buffer navigation ───────────────────────────────────────────
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        -- ── Window navigation (hjkl) ────────────────────────────────────
        ["<C-h>"] = { "<C-w>h", desc = "Move to left split" },
        ["<C-j>"] = { "<C-w>j", desc = "Move to below split" },
        ["<C-k>"] = { "<C-w>k", desc = "Move to above split" },
        ["<C-l>"] = { "<C-w>l", desc = "Move to right split" },

        -- ── Window resize ───────────────────────────────────────────────
        ["<C-Up>"]    = { "<cmd>resize +2<CR>",           desc = "Increase window height" },
        ["<C-Down>"]  = { "<cmd>resize -2<CR>",           desc = "Decrease window height" },
        ["<C-Left>"]  = { "<cmd>vertical resize -2<CR>",  desc = "Decrease window width" },
        ["<C-Right>"] = { "<cmd>vertical resize +2<CR>",  desc = "Increase window width" },

        -- ── Layout 3 pannelli ────────────────────────────────────────────
        -- Crea: [  50%  ] | [ top 50% ]
        --                    [ bot 50% ]
        -- <Leader>w3  → crea il layout
        -- <Tab>       → switcha tra i pannelli right-top e right-bottom
        ["<Leader>w3"] = {
          function()
            -- chiudi tutti i win extra, parti pulito
            vim.cmd "only"
            -- split verticale: cursore va a destra
            vim.cmd "vsplit"
            -- split orizzontale della finestra destra
            vim.cmd "split"
            -- torna alla finestra sinistra (pannello principale)
            vim.cmd "wincmd h"
            -- ridimensiona: sinistra al 50% della larghezza totale
            local w = vim.o.columns
            vim.cmd("vertical resize " .. math.floor(w / 2))
          end,
          desc = "Layout 3 pannelli (50%|25%/25%)",
        },

        -- Toggle tra right-top e right-bottom senza usare il mouse
        ["<Leader>wt"] = {
          function()
            local cur  = vim.api.nvim_get_current_win()
            local wins = vim.api.nvim_tabpage_list_wins(0)
            -- raccoglie le finestre "destre" (non la prima a sinistra)
            local right = {}
            for _, w in ipairs(wins) do
              local col = vim.api.nvim_win_get_position(w)[2]
              if col > 0 then right[#right + 1] = w end
            end
            if #right < 2 then return end
            table.sort(right, function(a, b)
              return vim.api.nvim_win_get_position(a)[1]
                   < vim.api.nvim_win_get_position(b)[1]
            end)
            -- switcha ciclicamente
            local idx = 1
            for i, w in ipairs(right) do
              if w == cur then idx = i; break end
            end
            local next = right[(idx % #right) + 1]
            vim.api.nvim_set_current_win(next)
          end,
          desc = "Switch right panels (top/bottom)",
        },

        -- <Tab> (normal mode): switcha tra right-top e right-bottom
        ["<Tab>"] = {
          function()
            local cur  = vim.api.nvim_get_current_win()
            local wins = vim.api.nvim_tabpage_list_wins(0)
            local right = {}
            for _, w in ipairs(wins) do
              local col = vim.api.nvim_win_get_position(w)[2]
              if col > 0 then right[#right + 1] = w end
            end
            if #right < 2 then
              -- Tab normale se non siamo in layout 3 pannelli
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>w", true, false, true), "n", false)
              return
            end
            table.sort(right, function(a, b)
              return vim.api.nvim_win_get_position(a)[1]
                   < vim.api.nvim_win_get_position(b)[1]
            end)
            local inRight = false
            local idx = 1
            for i, w in ipairs(right) do
              if w == cur then inRight = true; idx = i; break end
            end
            if not inRight then
              vim.api.nvim_set_current_win(right[1])
            else
              local next = right[(idx % #right) + 1]
              vim.api.nvim_set_current_win(next)
            end
          end,
          desc = "Switch right panels / next window",
        },

        -- ── LSP avanzato: call hierarchy + references ───────────────────
        -- Dove è USATA questa funzione (references in Telescope)
        ["<Leader>lr"] = {
          function() require("telescope.builtin").lsp_references() end,
          desc = "References (dove è usata)",
        },
        -- Cosa CHIAMA questa funzione (incoming calls)
        ["<Leader>li"] = {
          function() vim.lsp.buf.incoming_calls() end,
          desc = "Incoming calls (chi chiama questa funzione)",
        },
        -- Cosa viene CHIAMATO da questa funzione (outgoing calls)
        ["<Leader>lO"] = {
          function() vim.lsp.buf.outgoing_calls() end,
          desc = "Outgoing calls (cosa chiama questa funzione)",
        },
        -- Simboli nel file (funzioni, classi, metodi)
        ["<Leader>ls"] = {
          function() require("telescope.builtin").lsp_document_symbols() end,
          desc = "Simboli nel file",
        },
        -- Simboli nel workspace (tutto il progetto)
        ["<Leader>lS"] = {
          function() require("telescope.builtin").lsp_workspace_symbols() end,
          desc = "Simboli nel progetto",
        },
        -- Definizioni nel file (Telescope)
        ["gd"] = {
          function() require("telescope.builtin").lsp_definitions() end,
          desc = "Go to definition",
        },
        -- Implementazioni
        ["gi"] = {
          function() require("telescope.builtin").lsp_implementations() end,
          desc = "Go to implementation",
        },
        -- Type definition
        ["gy"] = {
          function() require("telescope.builtin").lsp_type_definitions() end,
          desc = "Go to type definition",
        },

        -- ── Git extra ───────────────────────────────────────────────────
        -- Conventional commit via commitizen (richiede: npm i -g commitizen cz-conventional-changelog)
        ["<Leader>gc"] = {
          function()
            Snacks.terminal("cz commit", { cwd = vim.fn.getcwd(), auto_close = false })
          end,
          desc = "Conventional commit (commitizen)",
        },
        ["<Leader>gd"] = { "<cmd>DiffviewOpen<CR>",       desc = "Diffview open" },
        ["<Leader>gD"] = { "<cmd>DiffviewClose<CR>",      desc = "Diffview close" },
        ["<Leader>gh"] = { "<cmd>DiffviewFileHistory<CR>", desc = "File history" },

        -- ── Trouble ─────────────────────────────────────────────────────
        ["<Leader>xx"] = { "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics (Trouble)" },
        ["<Leader>xX"] = { "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer diagnostics (Trouble)" },
        ["<Leader>xs"] = { "<cmd>Trouble symbols toggle<CR>", desc = "Symbols (Trouble)" },
        ["<Leader>xl"] = { "<cmd>Trouble lsp toggle<CR>",     desc = "LSP definitions (Trouble)" },
        ["<Leader>xL"] = { "<cmd>Trouble loclist toggle<CR>", desc = "Location list (Trouble)" },
        ["<Leader>xq"] = { "<cmd>Trouble qflist toggle<CR>",  desc = "Quickfix list (Trouble)" },
      },
    },
  },
}
