---@type LazySpec
return {
  "AstroNvim/astroui",
  ---@type AstroUIOpts
  opts = {
    colorscheme = "catppuccin-mocha",
    highlights = {
      init = {
        TabLineSel      = { fg = "#1a1a1a", bg = "#f5c518", bold = true },
        TabActiveYellow = { fg = "#1a1a1a", bg = "#f5c518", bold = true },
      },
      astrodark = {
        TabLineSel      = { fg = "#1a1a1a", bg = "#f5c518", bold = true },
        TabActiveYellow = { fg = "#1a1a1a", bg = "#f5c518", bold = true },
      },
      ["catppuccin-mocha"] = {
        TabLineSel      = { fg = "#1e1e2e", bg = "#f5c518", bold = true },
        TabActiveYellow = { fg = "#1e1e2e", bg = "#f5c518", bold = true },
      },
    },
    icons = {
      LSPLoading1 = "⠋",
      LSPLoading2 = "⠙",
      LSPLoading3 = "⠹",
      LSPLoading4 = "⠸",
      LSPLoading5 = "⠼",
      LSPLoading6 = "⠴",
      LSPLoading7 = "⠦",
      LSPLoading8 = "⠧",
      LSPLoading9 = "⠇",
      LSPLoading10 = "⠏",
    },
  },
}
