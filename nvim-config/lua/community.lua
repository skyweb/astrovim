---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  -- Packs linguaggi
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.python" },
  { import = "astrocommunity.pack.php" },
  { import = "astrocommunity.pack.bash" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.yaml" },
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.pack.markdown" },
  -- JavaScript / TypeScript / React / Next.js / Vue
  { import = "astrocommunity.pack.typescript" },
  { import = "astrocommunity.pack.vue" },
  -- Infrastruttura / Cloud (GCP + AWS)
  { import = "astrocommunity.pack.terraform" },
  { import = "astrocommunity.pack.docker" },
  { import = "astrocommunity.pack.tailwindcss" },
  -- Tema
  { import = "astrocommunity.colorscheme.catppuccin" },
  -- AI / Claude
  { import = "astrocommunity.ai.avante-nvim" },
  -- Database / SQL
  { import = "astrocommunity.pack.sql" },
  { import = "astrocommunity.pack.full-dadbod" },
  -- Docker
  { import = "astrocommunity.docker.lazydocker" },
  -- Git
  { import = "astrocommunity.git.neogit" },
  { import = "astrocommunity.git.diffview-nvim" },
  -- ── UI — cambia enabled = true/false per attivare/disattivare ───────────────
  --
  -- noice.nvim: cmdline e notifiche floating (molto visivo)
  { import = "astrocommunity.utility.noice-nvim" },
  { "folke/noice.nvim", enabled = true },  -- ← true/false

  -- bufferline.nvim: tab con stili (slant, thick, padded_slant…)
  -- sostituisce la bufferline di heirline
  { import = "astrocommunity.bars-and-lines.bufferline-nvim" },
  { "akinsho/bufferline.nvim", enabled = true },   -- ← true/false

  -- Utility
  { import = "astrocommunity.editing-support.todo-comments-nvim" },
  { import = "astrocommunity.editing-support.nvim-treesitter-endwise" },
  { import = "astrocommunity.editing-support.nvim-treesitter-context" },
  { import = "astrocommunity.code-runner.overseer-nvim" },
  { import = "astrocommunity.indent.indent-blankline-nvim" },
  { import = "astrocommunity.diagnostics.trouble-nvim" },
  { import = "astrocommunity.fuzzy-finder.telescope-nvim" },
}
