# Neovim config

Personal Neovim config (nightly, 0.11+ APIs), Lua only. This directory is a git submodule of
`nix-conf`: commit here, not in the parent repo.

## Layout

- `init.lua`: leader keys, lazy.nvim bootstrap, plugin spec imports. A new subdirectory under
  `lua/plugins/` needs its own `{ import = "plugins.<dir>" }` line here.
- `plugin/NN_*.lua`: core config without plugins (options, mappings, autocmds, LSP, user commands,
  statusline, winbar). Loaded in numeric order; keep the prefix scheme.
- `lua/plugins/*.lua`: one lazy.nvim spec per file, each returning a spec table.
  Subdirectories group specs: `completion`, `debug`, `langs`, `langs/rust`, `lsp`, `snacks`,
  `treesitter`, `ui`. Imports are not recursive, so nested directories are imported separately.
- `lua/plugins/ignore/`: disabled specs, not imported. Move a spec here to disable it instead of
  deleting it.
- `after/lsp/<server>.lua`: per-server config for the native `vim.lsp.config` mechanism.
- `after/ftplugin/<ft>.lua`: filetype-local settings.
- `lua/utils.lua`: shared helpers. Check here before writing a new one.
- `lua/snippets/`, `queries/`, `schemas/`, `scripts/`, `spell/`, `syntax/`, `ftdetect/`: as named.

## Conventions

- Format only the files you touch: `stylua <file>` (config in `stylua.toml`: 4 spaces, 100
  columns, double quotes, sorted requires). Never run `stylua .`; many existing files are not
  formatted and would produce an unrelated diff.
- Prefer built-in Neovim APIs (`vim.lsp.config`, `vim.keymap.set`, `vim.api.nvim_create_autocmd`,
  `vim.uv`) over a plugin or a compatibility shim.
- Globals known to lua_ls are `vim`, `MiniFiles` and `Snacks` (`.luarc.json`). Add new ones there.
- Commit messages follow Conventional Commits, e.g. `fix(clangd): ...`, `feat: ...`.

## Verify

- Format check: `stylua --check <touched files>`
- Load check: `nvim --headless "+qa"` must print nothing and exit 0.
- Single file: `nvim --headless "+luafile <path>" "+qa"`

## Do not

- Edit `lazy-lock.json` by hand, or run `:Lazy update` / `:Lazy sync` unless asked. The lockfile
  is tracked even though `.gitignore` lists it.
- Edit `spell/*.add`, or `schemas/*.json` directly. Schemas come from
  `scripts/gen-azure-pipelines-schemas.sh`.
- Install plugins or LSP servers (Mason) as a side effect of testing.
