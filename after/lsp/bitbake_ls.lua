return {
    cmd = { 'language-server-bitbake', '--stdio' },
    filetypes = { 'bitbake' },
    root_marker = { ".git", "Makefile" },
    single_file_support = false,
}
