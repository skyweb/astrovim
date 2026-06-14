---@type LazySpec
return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        -- ── LSP servers ───────────────────────────────────────────────────
        "lua-language-server",
        "intelephense",            -- PHP (supporto Laravel + Blade)
        "pyright",                 -- Python (supporto Django)
        "bash-language-server",
        "typescript-language-server", -- JS / TS / React / Next.js
        "tailwindcss-language-server",
        "some-sass-language-server",  -- SCSS / Sass
        "css-lsp",
        "html-lsp",
        "json-lsp",
        "yaml-language-server",
        "emmet-language-server",   -- HTML / JSX emmet

        -- ── Python tools ──────────────────────────────────────────────────
        "black",                   -- formatter PEP8
        "isort",                   -- import sorter
        "ruff",                    -- fast linter + formatter (sostituisce flake8)
        "pylint",                  -- linter avanzato
        "mypy",                    -- type checker

        -- ── PHP / Laravel tools ────────────────────────────────────────────
        "php-cs-fixer",            -- formatter PSR-12
        "phpcs",                   -- PHP_CodeSniffer
        "phpmd",                   -- PHP Mess Detector
        "phpstan",                 -- static analyzer

        -- ── Bash / Shell tools ────────────────────────────────────────────
        "shfmt",                   -- formatter
        "shellcheck",              -- linter

        -- ── JS / TS / React / Next.js tools ──────────────────────────────
        "eslint_d",                -- ESLint daemon (veloce)
        "prettierd",               -- Prettier daemon (veloce)

        -- ── Formatters generici ───────────────────────────────────────────
        "stylua",                  -- Lua
        "prettier",                -- fallback HTML/CSS/JSON/YAML/MD

        -- ── Debuggers ─────────────────────────────────────────────────────
        "debugpy",                 -- Python debugger
        "php-debug-adapter",       -- PHP debugger
        "js-debug-adapter",        -- JS/TS/Node debugger

        -- ── Utility ───────────────────────────────────────────────────────
        "tree-sitter-cli",
        "jq",
      },
    },
  },
}
