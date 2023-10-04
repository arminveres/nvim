return {
    "ThePrimeagen/harpoon",
    keys = {
        {
            "<leader>ha",
            function()
                require("harpoon.mark").add_file()
            end,
            desc = "Harpoon Add File",
        },
        {
            "\\h",
            function()
                require("harpoon.ui").toggle_quick_menu()
            end,
            desc = "Harpoon Toggle Quick Menu",
        },
        {
            "\\a",
            function()
                require("harpoon.ui").nav_file(1)
            end,
            desc = "Harpoon goto file 1",
        },
        {
            "\\s",
            function()
                require("harpoon.ui").nav_file(2)
            end,
            desc = "Harpoon goto file 2",
        },
        {
            "\\d",
            function()
                require("harpoon.ui").nav_file(3)
            end,
            desc = "Harpoon goto file 3",
        },
        {
            "\\f",
            function()
                require("harpoon.ui").nav_file(4)
            end,
            desc = "Harpoon goto file 4",
        },
        {
            "\\g",
            function()
                require("harpoon.ui").nav_file(5)
            end,
            desc = "Harpoon goto file 5",
        },
    },
}
