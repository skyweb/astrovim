---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    treesitter = {
      highlight = true,
      indent = true,
      auto_install = true,
      ensure_installed = {
        -- Core
        "lua", "vim", "vimdoc", "query",
        -- Python / Django
        "python",
        -- PHP / Laravel
        "php", "phpdoc",
        -- Bash / Shell
        "bash",
        -- Web / React / Next.js / Vue
        "html", "css", "scss",
        "javascript", "typescript", "tsx", "jsdoc",
        "vue",
        -- Data / Config
        "json", "json5", "yaml", "toml", "xml", "ini",
        -- Docs
        "markdown", "markdown_inline", "rst",
        -- Git
        "git_config", "git_rebase", "gitcommit", "gitignore", "diff",
        -- Build systems
        "make",                         -- Makefile
        -- Infrastruttura / Cloud
        "hcl",                          -- Terraform
        "helm",                         -- Kubernetes Helm charts
        -- Misc
        "regex", "comment", "dockerfile", "sql", "graphql",
      },
    },
  },
}
