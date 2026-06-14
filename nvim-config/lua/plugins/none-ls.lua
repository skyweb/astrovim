---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    local null_ls = require "null-ls"

    opts.sources = require("astrocore").list_insert_unique(opts.sources, {
      -- ── Python ──────────────────────────────────────────────────────────
      null_ls.builtins.formatting.black.with { extra_args = { "--line-length", "88" } },
      null_ls.builtins.formatting.isort.with { extra_args = { "--profile", "black" } },
      null_ls.builtins.diagnostics.ruff,
      null_ls.builtins.formatting.ruff.with {
        args = { "format", "--stdin-filename", "$FILENAME", "-" },
      },

      -- ── PHP / Laravel ────────────────────────────────────────────────────
      null_ls.builtins.formatting.phpcsfixer.with {
        args = { "--no-interaction", "--quiet", "fix", "$FILENAME" },
      },
      null_ls.builtins.diagnostics.phpcs.with {
        args = { "--report=emacs", "-s", "$FILENAME" },
      },
      null_ls.builtins.diagnostics.phpmd.with {
        args = { "$FILENAME", "text", "cleancode,codesize,controversial,design,naming,unusedcode" },
      },

      -- ── Bash / Shell ────────────────────────────────────────────────────
      null_ls.builtins.formatting.shfmt.with { extra_args = { "-i", "2", "-ci" } },
      null_ls.builtins.diagnostics.shellcheck.with {
        diagnostics_format = "#{m} [#{c}]",
      },

      -- ── JS / TS / React / Next.js / SCSS ────────────────────────────────
      null_ls.builtins.formatting.prettierd.with {
        filetypes = {
          "javascript", "javascriptreact", "typescript", "typescriptreact",
          "css", "scss", "less",
          "html", "json", "jsonc", "yaml", "markdown",
          "graphql",
        },
      },
      null_ls.builtins.diagnostics.eslint_d.with {
        condition = function(utils)
          return utils.root_has_file {
            ".eslintrc", ".eslintrc.js", ".eslintrc.cjs",
            ".eslintrc.json", "eslint.config.js", "eslint.config.mjs",
          }
        end,
      },
      null_ls.builtins.code_actions.eslint_d.with {
        condition = function(utils)
          return utils.root_has_file {
            ".eslintrc", ".eslintrc.js", ".eslintrc.cjs",
            ".eslintrc.json", "eslint.config.js", "eslint.config.mjs",
          }
        end,
      },

      -- ── Lua ─────────────────────────────────────────────────────────────
      null_ls.builtins.formatting.stylua,
    })
  end,
}
