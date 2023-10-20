return {
    {
        "preservim/vim-pencil",
        cmd = {
            "Pencil",
            "PencilToggle",
            "PencilSort",
            "PencilHard",
            "TogglePencil",
            "SoftPencil",
            "HardPendil",
        },
        init = function()
            vim.g["pencil#conceallevel"] = 0
        end,
    },
}
