---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  -- Alcuni builtins (eslint_d, ecc.) sono stati spostati nel pacchetto extras
  dependencies = { "nvimtools/none-ls-extras.nvim" },
  opts = function(_, opts)
    local null_ls = require "null-ls"

    -- Helper: aggiunge il source solo se il builtin esiste
    local function add(builtin, config)
      if not builtin then return nil end
      return config and builtin.with(config) or builtin
    end

    -- Extras spostati fuori da null-ls core
    local eslint_d_diag    = require "none-ls.diagnostics.eslint_d"
    local eslint_d_actions = require "none-ls.code_actions.eslint_d"

    local eslint_condition = {
      condition = function(utils)
        return utils.root_has_file {
          ".eslintrc", ".eslintrc.js", ".eslintrc.cjs",
          ".eslintrc.json", "eslint.config.js", "eslint.config.mjs",
        }
      end,
    }

    opts.sources = require("astrocore").list_insert_unique(opts.sources, {
      -- ── Python ──────────────────────────────────────────────────────────
      -- ruff / pylint: LSP nativo via Mason
      add(null_ls.builtins.formatting.black,
          { extra_args = { "--line-length", "88" } }),
      add(null_ls.builtins.formatting.isort,
          { extra_args = { "--profile", "black" } }),

      -- ── PHP / Laravel ────────────────────────────────────────────────────
      add(null_ls.builtins.formatting.phpcsfixer,
          { args = { "--no-interaction", "--quiet", "fix", "$FILENAME" } }),
      add(null_ls.builtins.diagnostics.phpcs,
          { args = { "--report=emacs", "-s", "$FILENAME" } }),
      add(null_ls.builtins.diagnostics.phpmd,
          { args = { "$FILENAME", "text", "cleancode,codesize,controversial,design,naming,unusedcode" } }),

      -- ── Bash / Shell ────────────────────────────────────────────────────
      -- shellcheck: gestito da bash-language-server
      add(null_ls.builtins.formatting.shfmt,
          { extra_args = { "-i", "2", "-ci" } }),

      -- ── JS / TS / React / Next.js / SCSS ────────────────────────────────
      add(null_ls.builtins.formatting.prettierd, {
        filetypes = {
          "javascript", "javascriptreact", "typescript", "typescriptreact",
          "css", "scss", "less",
          "html", "json", "jsonc", "yaml", "markdown",
          "graphql",
        },
      }),
      eslint_d_diag.with(eslint_condition),
      eslint_d_actions.with(eslint_condition),

      -- ── OpenAPI / Swagger (Spectral) ─────────────────────────────────────
      -- Linter OpenAPI di Stoplight: valida spec 2.0/3.0/3.1 con regole avanzate
      add(null_ls.builtins.diagnostics.spectral, {
        filetypes = { "yaml", "json" },
        runtime_condition = function()
          local lines = vim.api.nvim_buf_get_lines(0, 0, 10, false)
          for _, line in ipairs(lines) do
            if line:match "^openapi:" or line:match "^swagger:" then return true end
          end
          return false
        end,
      }),

      -- ── Security / OWASP ────────────────────────────────────────────────
      -- Semgrep: OWASP Top 10 su tutti i linguaggi (lento → solo al salvataggio)
      add(null_ls.builtins.diagnostics.semgrep, {
        extra_args = { "--config", "p/owasp-top-ten" },
        method     = null_ls.methods.DIAGNOSTICS_ON_SAVE,
      }),

      -- PHPStan: analisi statica PHP — attivo solo se phpstan.neon esiste nel progetto
      add(null_ls.builtins.diagnostics.phpstan, {
        condition = function(utils)
          return utils.root_has_file { "phpstan.neon", "phpstan.neon.dist", "phpstan.dist.neon" }
        end,
      }),

      -- ── Lua ─────────────────────────────────────────────────────────────
      add(null_ls.builtins.formatting.stylua),
    })

    -- Rimuove eventuali nil dalla lista
    opts.sources = vim.tbl_filter(function(s) return s ~= nil end, opts.sources)
  end,
}
