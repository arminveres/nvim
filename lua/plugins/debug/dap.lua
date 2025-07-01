-- Reference:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/dap/core.lua

---@param config {type?:string, args?:string[]|fun():string[]?}
local function get_args(config)
    local args = type(config.args) == "function" and (config.args() or {}) or config.args or {} --[[@as string[] | string ]]
    local args_str = type(args) == "table" and table.concat(args, " ") or args --[[@as string]]

    config = vim.deepcopy(config)
    ---@cast args string[]
    config.args = function()
        local new_args = vim.fn.expand(vim.fn.input("Run with args: ", args_str)) --[[@as string]]
        if config.type and config.type == "java" then
            ---@diagnostic disable-next-line: return-type-mismatch
            return new_args
        end
        return require("dap.utils").splitstr(new_args)
    end
    return config
end

return {
    -- NOTE: Yes, you can install new plugins here!
    "mfussenegger/nvim-dap",
    -- event = "VeryLazy",
    keys = {
        {
            "<leader>dB",
            function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
            desc = "Breakpoint Condition",
        },
        {
            "<leader>db",
            function() require("dap").toggle_breakpoint() end,
            desc = "Toggle Breakpoint",
        },
        {
            "<leader>dc",
            function() require("dap").continue() end,
            desc = "Run/Continue",
        },
        {
            "<leader>da",
            function() require("dap").continue({ before = get_args }) end,
            desc = "Run with Args",
        },
        {
            "<leader>dC",
            function() require("dap").run_to_cursor() end,
            desc = "Run to Cursor",
        },
        {
            "<leader>dg",
            function() require("dap").goto_() end,
            desc = "Go to Line (No Execute)",
        },
        {
            "<leader>di",
            function() require("dap").step_into() end,
            desc = "Step Into",
        },
        {
            "<leader>dj",
            function() require("dap").down() end,
            desc = "Down",
        },
        {
            "<leader>dk",
            function() require("dap").up() end,
            desc = "Up",
        },
        {
            "<leader>dl",
            function() require("dap").run_last() end,
            desc = "Run Last",
        },
        {
            "<leader>do",
            function() require("dap").step_out() end,
            desc = "Step Out",
        },
        {
            "<leader>dO",
            function() require("dap").step_over() end,
            desc = "Step Over",
        },
        {
            "<leader>dP",
            function() require("dap").pause() end,
            desc = "Pause",
        },
        {
            "<leader>dr",
            function() require("dap").repl.toggle() end,
            desc = "Toggle REPL",
        },
        {
            "<leader>ds",
            function() require("dap").session() end,
            desc = "Session",
        },
        {
            "<leader>dt",
            function() require("dap").terminate() end,
            desc = "Terminate",
        },
        {
            "<leader>dw",
            function() require("dap.ui.widgets").hover() end,
            desc = "Widgets",
        },
    },
    -- NOTE: And you can specify dependencies as well
    dependencies = {
        -- Creates a beautiful debugger UI
        {
            "rcarriga/nvim-dap-ui",
            dependencies = {
                "nvim-neotest/nvim-nio",
            },
        },
        "williamboman/mason.nvim",
        "jay-babu/mason-nvim-dap.nvim",
        "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        require("mason-nvim-dap").setup({
            -- Makes a best effort to setup the various debuggers with
            -- reasonable debug configurations
            automatic_setup = true,

            -- You can provide additional configuration to the handlers,
            -- see mason-nvim-dap README for more information
            handlers = {},

            -- You'll need to check that you have the required things installed
            -- online, please don't ask me how to install them :)
            ensure_installed = {
                -- Update this to ensure that you have the debuggers for the langs you want
                -- "delve",
            },
        })

        -- Dap UI setup
        -- For more information, see |:help nvim-dap-ui|
        dapui.setup({
            -- Set icons to characters that are more likely to work in every terminal.
            --    Feel free to remove or use ones that you like more! :)
            --    Don't feel like these are good choices.
            icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
            controls = {
                icons = {
                    pause = "⏸",
                    play = "▶",
                    step_into = "⏎",
                    step_over = "⏭",
                    step_out = "⏮",
                    step_back = "b",
                    run_last = "▶▶",
                    terminate = "⏹",
                    disconnect = "⏏",
                },
            },
        })

        -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
        vim.keymap.set("n", "<F7>", dapui.toggle, { desc = "Debug: See last session result." })

        dap.listeners.after.event_initialized["dapui_config"] = dapui.open
        dap.listeners.before.event_terminated["dapui_config"] = dapui.close
        dap.listeners.before.event_exited["dapui_config"] = dapui.close

        -- Install golang specific config
        -- require("dap-go").setup()

        -- See
        -- https://sourceware.org/gdb/current/onlinedocs/gdb.html/Interpreters.html
        -- https://sourceware.org/gdb/current/onlinedocs/gdb.html/Debugger-Adapter-Protocol.html
        -- dap.adapters.gdb = {
        --     id = "gdb",
        --     type = "executable",
        --     command = "gdb",
        --     args = { "--quiet", "--interpreter=dap" },
        -- }
        -- dap.configurations.cpp = {
        --     {
        --         name = "Run executable (GDB)",
        --         type = "gdb",
        --         request = "launch",
        --         -- This requires special handling of 'run_last', see
        --         -- https://github.com/mfussenegger/nvim-dap/issues/1025#issuecomment-1695852355
        --         program = function()
        --             local path = vim.fn.input({
        --                 prompt = "Path to executable: ",
        --                 default = vim.fn.getcwd() .. "/",
        --                 completion = "file",
        --             })

        --             return (path and path ~= "") and path or dap.ABORT
        --         end,
        --     },
        --     {
        --         name = "Run executable with arguments (GDB)",
        --         type = "gdb",
        --         request = "launch",
        --         -- This requires special handling of 'run_last', see
        --         -- https://github.com/mfussenegger/nvim-dap/issues/1025#issuecomment-1695852355
        --         program = function()
        --             local path = vim.fn.input({
        --                 prompt = "Path to executable: ",
        --                 default = vim.fn.getcwd() .. "/",
        --                 completion = "file",
        --             })

        --             return (path and path ~= "") and path or dap.ABORT
        --         end,
        --         args = function()
        --             local args_str = vim.fn.input({
        --                 prompt = "Arguments: ",
        --             })
        --             return vim.split(args_str, " +")
        --         end,
        --     },
        --     {
        --         name = "Attach to process (GDB)",
        --         type = "gdb",
        --         request = "attach",
        --         processId = require("dap.utils").pick_process,
        --     },
        -- }
    end,
}
