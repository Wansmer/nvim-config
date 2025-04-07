# Neovim 0.11+ configuration

Personal configuration for Neovim with a focus on web (vue3, js, ts) and lua-plugins development.

## Requirements

### Common requirements

1. [Neovim 0.11.+](https://github.com/neovim/neovim);
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
