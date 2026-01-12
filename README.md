# nvim config

[![Requires Neovim 0.11+](https://img.shields.io/badge/requires-nvim%200.7%2B-9cf?logo=neovim)](https://neovim.io/)

![image](https://github.com/arminveres/nvim/assets/45210978/b7a9d79d-b725-4011-ad9c-898a3b7179d2)

## Features

- Easy and simple LSP usage, automatic install and setup [Mason](https://github.com/williamboman/mason.nvimhttps://github.com/williamboman/mason.nvim)
- Plugin management through [Lazy](https://github.com/folke/lazy.nvimhttps://github.com/folke/lazy.nvim)
- Custom statusline and winbar (partly based on `dropbar.nvim`)
- Treesitter `main` branch support

## Requirements

- `tree-sitter-cli` for Treesitter setup. `cargo binstall tree-sitter-cli`
- `ripgrep` for faster and more modern grepping. `cargo binstall ripgrep`
- `fd-find` for more modern file finding. `cargo binstall fd-find`
- TeX distribution like `texlive`
- `pandoc` for document conversions

## TODO

- [ ] Add some whitespace highlighter, e.g.,[mini-trailspace.nvim](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-trailspace.md)
