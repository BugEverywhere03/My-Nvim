require("monokai-pro").setup({
  transparent_background = true,
  terminal_colors = true,
  devicons = true,
  styles = {
    comment = { italic = true },
    keyword = { italic = true },
    type = { italic = true },
    storageclass = { italic = true },
    structure = { italic = true },
    parameter = { italic = true },
    annotation = { italic = true },
    tag_attribute = { italic = true },
  },
  filter = "pro", -- classic | octagon | pro | machine | ristretto | spectrum
  day_night = {
    enable = false,
    day_filter = "pro",
    night_filter = "spectrum",
  },
  inc_search = "background", -- underline | background
  background_clear = {
    "toggleterm",
    "telescope",
    "renamer",
    "notify",
    "harpoon"
  },
  plugins = {
    bufferline = {
      underline_selected = false,
      underline_visible = false,
      underline_fill = false,
      bold = true,
    },
    indent_blankline = {
      context_highlight = "pro", -- default | pro
      context_start_underline = false,
    },
  },
  disabled_plugins = {
    "bufferline",
    "mason",
  },

  })
function ColorMyPencils(color)
	color = color or "monokai-pro"
	vim.cmd.colorscheme(color)
    local highlights = {
        "Normal",
        "NormalFloat",
        "NormalNC",
    }
    for _, group in ipairs(highlights) do
        vim.api.nvim_set_hl(0, group, { bg = "none" })
    end
end
ColorMyPencils()
vim.keymap.set("n", "<leader>cl" , function() vim.cmd("lua ColorMyPencils()") end, {})
