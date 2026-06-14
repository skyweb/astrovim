-- Autocommands e impostazioni finali

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- ── PATH: aggiungi le dir dei tool installati ────────────────────────────────
local extra_paths = {
  vim.fn.expand "~/.composer/vendor/bin",           -- phpcs, phpmd, php-cs-fixer, phpstan
  vim.fn.expand "~/.nvm/versions/node/v22.20.0/bin", -- typescript-language-server, prettier, eslint
  vim.fn.expand "~/Library/Python/3.12/bin",         -- black, isort, ruff, pylint, mypy
  "/usr/local/bin",                                   -- shellcheck, shfmt, bash-language-server, jq, php
}
local current_path = vim.env.PATH or ""
for _, p in ipairs(extra_paths) do
  if not current_path:find(p, 1, true) then
    vim.env.PATH = p .. ":" .. vim.env.PATH
  end
end

-- ── PHP / Laravel ────────────────────────────────────────────────────────────
local phpGroup = augroup("PhpLaravel", { clear = true })
autocmd("FileType", {
  group = phpGroup,
  pattern = { "php", "blade" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
  end,
})

-- ── Python / Django ──────────────────────────────────────────────────────────
local pyGroup = augroup("PythonDjango", { clear = true })
autocmd("FileType", {
  group = pyGroup,
  pattern = "python",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
    vim.opt_local.colorcolumn = "88"
  end,
})

-- ── JS / TS / React / Next.js / SCSS ─────────────────────────────────────────
local jsGroup = augroup("JsTsReact", { clear = true })
autocmd("FileType", {
  group = jsGroup,
  pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact", "css", "scss", "json" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})

-- ── Bash / Shell ─────────────────────────────────────────────────────────────
local shGroup = augroup("BashShell", { clear = true })
autocmd("FileType", {
  group = shGroup,
  pattern = { "sh", "bash", "zsh" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})

-- ── Highlight on yank ────────────────────────────────────────────────────────
local yankGroup = augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
  group = yankGroup,
  callback = function() vim.highlight.on_yank { higroup = "IncSearch", timeout = 150 } end,
})

-- ── Ripristina la posizione del cursore all'apertura del file ─────────────────
local cursorGroup = augroup("RestoreCursor", { clear = true })
autocmd("BufReadPost", {
  group = cursorGroup,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
