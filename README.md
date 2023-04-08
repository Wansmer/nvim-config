# Neovim 0.9+ configuration

Personal configuration for Neovim with a focus on web development (vue3, js, ts).

## Requirements

1. [Neovim 0.9.+](https://github.com/neovim/neovim);
2. [rigrep](https://github.com/BurntSushi/ripgrep);
3. [fd](https://github.com/sharkdp/fd);
4. `wget`/`curl`;
5. `git`;
6. `node`, `npm`;
7. [NerdFonts](https://www.nerdfonts.com) _(optional)_;
8. [im-select](https://github.com/daipeihust/im-select) _(optional)_;

## Installation

Install Neovim and requirements with your plugin manager.
[Homebrew](https://brew.sh) example:

```bash
$ brew install neovim --HEAD
$ brew install ripgrep
$ brew install fd
$ brew install node
$ brew install wget
```

Clone the repo to `config` directory and run Neovim:

```bash
$ git clone https://github.com/Wansmer/nvim-config ~/.config/nvim
$ nvim
```

## LSP

```bash
$ npm i -g typescript-language-server typescript
$ npm i -g @volar/vue-language-server
$ npm i -g vscode-langservers-extracted # css, html, json
$ npm i -g emmet-ls
$ brew install lua-language-server
$ brew install marksman
```
