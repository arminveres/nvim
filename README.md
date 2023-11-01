# nvim config

![image](https://user-images.githubusercontent.com/45210978/233858627-e067a2a4-4b18-4a2e-b079-6fd26ada45ea.png)

> **Warning**: remove all remaining packer files from the data folder, as it may cause conflicts and unnecessary errors!

## Features

- Easy and simple LSP usage, automatic install and setup [Mason](https://github.com/williamboman/mason.nvimhttps://github.com/williamboman/mason.nvim)
- Plugin management through [Lazy](https://github.com/folke/lazy.nvimhttps://github.com/folke/lazy.nvim)

## Requirements

- nvim >= 0.9
- TeX distribution like `texlive`
- `pandoc` for document conversions
- `ripgrep` for faster and more modern grepping
- `fd-find` for more modern file finding

#### TODO

- add debug protocol DAP [nvim-dap](https://github.com/mfussenegger/nvim-dap)
  and [dap-ui](https://github.com/rcarriga/nvim-dap-ui)
- possibly replace `harpoon.nvim` with `graple.nvim`
- move `json` snippets to `lua` snippets
- possibly replace `nvim-scrollbar` with `satellite.nvim`
- MAJOR rewrite, with new layout for core and plugins. (Also bring back the damned splashscreen!!!)
