local present, toggler = pcall(require, 'nvim-toggler')

if not present then
  return
end

toggler.setup({
  inverses = {
    ['top'] = 'bottom',
    ['before'] = 'after',
    ['start'] = 'end',
    ['vim'] = 'emacs',
    ['true'] = 'false',
    ['yes'] = 'no',
    ['on'] = 'off',
    ['left'] = 'right',
    ['up'] = 'down',
    ['!='] = '==',
    ['!=='] = '===',
  },
})
