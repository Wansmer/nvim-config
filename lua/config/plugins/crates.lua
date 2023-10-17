return {
  'saecki/crates.nvim',
  enabled = false,
  event = { 'BufRead Cargo.toml' },
  requires = {
    { 'nvim-lua/plenary.nvim' },
  },
  config = function()
    require('crates').setup({
      null_ls = {
        enabled = true,
        name = 'Crates',
      },
    })
  end,
}
