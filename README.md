# Neovim 0.9+ configuration

Personal configuration for Neovim with a focus on web (vue3, js, ts) and lua-plugins development.

## Requirements

### Common requirements

1. [Neovim 0.10.+](https://github.com/neovim/neovim);
2. [rigrep](https://github.com/BurntSushi/ripgrep);
3. `git`;
4. `wget`/`curl`;

### Plugin dependencies

1. [fd](https://github.com/sharkdp/fd) for [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim);
2. [NerdFonts](https://www.nerdfonts.com) for pretty icons;
3. [im-select](https://github.com/daipeihust/im-select) for [langmapper.nvim](https://github.com/Wansmer/langmapper.nvim);
4. [node](https://nodejs.org/en) for [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim);

## Installation

Install Neovim and dependencies (including lsp, linters and formatters) with your package manager.
[Homebrew](https://brew.sh) example:

```bash
$ brew install neovim # or `brew install neovim --HEAD` to use nightly
$ brew install ripgrep
$ brew install fd
$ brew install node
```

Clone the repo to `config` directory and run Neovim:

```bash
$ git clone https://github.com/Wansmer/nvim-config ~/.config/nvim
$ nvim
```

## LSP, linters, formatters

I have been using `Mason` to manage LSP, linters and formatters, but I came to the conclusion that it is not correct to use Neovim as a package manager.

### LSP

To auto setup LSP uses [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig).

To ovveride lsp-config for specific servers add same-name file with settings to [lsp section](/lua/config/lsp/servers)

```bash
$ npm i -g typescript-language-server typescript
$ npm i -g @volar/vue-language-server
$ npm i -g vscode-langservers-extracted # css, html, json
$ npm i -g emmet-ls
$ brew install lua-language-server
$ brew install marksman
```

### Linters and formatters

[Null-ls](https://github.com/jose-elias-alvarez/null-ls.nvim) replace lsp-builtins linters and formatters for specific filetypes.

```bash
$ brew install stylua
$ npm i -g eslint # or `npm init @eslint/config` to generate default `.eslintrc`
$ npm i -g prettier
$ npm i -g stylelint
```
