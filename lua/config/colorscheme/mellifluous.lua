require("mellifluous").setup({
  dim_inactive = false,
  color_set = "mountain", -- 'mellifluous', 'alduin', 'tender', 'mountain'
  highlight_overrides = {
    dark = function(hl, _) -- dark variant of the color set
      hl.set("WinBar", { link = "Normal" })
      hl.set("WinBarNC", { link = "Normal" })
    end,
  },
  styles = { comments = { italic = true } },
  transparent_background = { enabled = false },
  flat_background = {
    line_numbers = true,
    floating_windows = false,
    file_tree = false,
    cursor_line_number = true,
  },
  plugins = {
    cmp = true,
    gitsigns = true,
    indent_blankline = true,
    nvim_tree = {
      enabled = true,
      show_root = false,
    },
    neo_tree = {
      enabled = true,
    },
    telescope = {
      enabled = true,
      nvchad_like = true,
    },
    startify = true,
  },
})
