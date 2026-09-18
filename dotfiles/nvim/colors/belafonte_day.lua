local colors = {
  bg = "#d4ccb9",
  fg = "#45363b",
  cursor = "#45363b",
  selection_bg = "#958b83",
  selection_fg = "#d4ccb9",

  black = "#20111a",
  red = "#bd100d",
  green = "#858062",
  yellow = "#e9a448",
  blue = "#416978",
  magenta = "#96522b",
  cyan = "#98999c",
  white = "#958b83",

  bright_black = "#5e5252",
  bright_white = "#d4ccb9",
}

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end

vim.o.termguicolors = true
vim.o.background = "light"
vim.g.colors_name = "belafonte_day"

local highlights = {
  Normal = { fg = colors.fg, bg = colors.bg },
  NormalFloat = { fg = colors.fg, bg = colors.bg },
  Comment = { fg = colors.bright_black, italic = true },
  Constant = { fg = colors.magenta },
  String = { fg = colors.green },
  Character = { fg = colors.green },
  Number = { fg = colors.magenta },
  Boolean = { fg = colors.magenta },
  Float = { fg = colors.magenta },
  Identifier = { fg = colors.blue },
  Function = { fg = colors.magenta },
  Statement = { fg = colors.red },
  Conditional = { fg = colors.red },
  Repeat = { fg = colors.red },
  Label = { fg = colors.red },
  Operator = { fg = colors.fg },
  Keyword = { fg = colors.red },
  Exception = { fg = colors.red },
  PreProc = { fg = colors.cyan },
  Include = { fg = colors.blue },
  Define = { fg = colors.cyan },
  Macro = { fg = colors.cyan },
  PreCondit = { fg = colors.cyan },
  Type = { fg = colors.magenta },
  StorageClass = { fg = colors.blue},
  Structure = { fg = colors.blue },
  Typedef = { fg = colors.blue },
  Special = { fg = colors.cyan },
  SpecialChar = { fg = colors.cyan },
  Tag = { fg = colors.red },
  Delimiter = { fg = colors.fg },
  SpecialComment = { fg = colors.bright_black },
  Debug = { fg = colors.red },
  Underlined = { underline = true },
  Ignore = { fg = colors.bright_black },
  Error = { fg = colors.red, bold = true },
  Todo = { fg = colors.blue, bold = true },

  Cursor = { fg = colors.bg, bg = colors.cursor },
  CursorLine = { bg = colors.white },
  CursorColumn = { bg = colors.white },
  ColorColumn = { bg = colors.white },
  LineNr = { fg = colors.bright_black },
  CursorLineNr = { fg = colors.fg, bold = true },
  Visual = { bg = colors.selection_bg, fg = colors.selection_fg },
  VisualNOS = { bg = colors.selection_bg },
  Search = { fg = colors.bg, bg = colors.blue },
  IncSearch = { fg = colors.bg, bg = colors.red },
  MatchParen = { fg = colors.red, bold = true },

  Pmenu = { fg = colors.fg, bg = colors.white },
  PmenuSel = { fg = colors.selection_fg, bg = colors.selection_bg },
  PmenuSbar = { bg = colors.white },
  PmenuThumb = { bg = colors.bright_black },

  StatusLine = { fg = colors.fg, bg = colors.white },
  StatusLineNC = { fg = colors.bright_black, bg = colors.white },
  TabLine = { fg = colors.bright_black, bg = colors.white },
  TabLineFill = { bg = colors.white },
  TabLineSel = { fg = colors.fg, bg = colors.bg },

  VertSplit = { fg = colors.white },
  Folded = { fg = colors.bright_black, bg = colors.white },
  FoldColumn = { fg = colors.bright_black, bg = colors.bg },
  SignColumn = { bg = colors.bg },

  DiffAdd = { fg = colors.green, bg = colors.white },
  DiffChange = { fg = colors.blue, bg = colors.white },
  DiffDelete = { fg = colors.red, bg = colors.white },
  DiffText = { fg = colors.blue, bg = colors.white, bold = true },

  SpellBad = { undercurl = true, sp = colors.red },
  SpellCap = { undercurl = true, sp = colors.blue },
  SpellLocal = { undercurl = true, sp = colors.cyan },
  SpellRare = { undercurl = true, sp = colors.magenta },

  -- TreeSitter
  ["@variable"] = { fg = colors.fg },
  ["@variable.builtin"] = { fg = colors.magenta },
  ["@property"] = { fg = colors.blue },
  ["@parameter"] = { fg = colors.fg },
  ["@function"] = { fg = colors.yellow },
  ["@function.builtin"] = { fg = colors.yellow },
  ["@keyword"] = { fg = colors.red },
  ["@keyword.function"] = { fg = colors.red },
  ["@keyword.return"] = { fg = colors.red },
  ["@conditional"] = { fg = colors.red },
  ["@repeat"] = { fg = colors.red },
  ["@string"] = { fg = colors.green },
  ["@number"] = { fg = colors.magenta },
  ["@boolean"] = { fg = colors.magenta },
  ["@constant"] = { fg = colors.magenta },
  ["@constant.builtin"] = { fg = colors.magenta },
  ["@type"] = { fg = colors.yellow },
  ["@type.builtin"] = { fg = colors.yellow },
  ["@comment"] = { fg = colors.bright_black, italic = true },
}

for group, opts in pairs(highlights) do
  vim.api.nvim_set_hl(0, group, opts)
end
