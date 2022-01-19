local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PackerBootstrap = fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    })
end

vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
    -- Packer can manage itself
    use({
        "wbthomason/packer.nvim",
        opt = false,
    })

    require("plugins.monokai")(use)

    -- require("plugins.feline")(use)
    require("plugins.lualine")(use)
    require("plugins.luatab")(use)

    require("plugins.alpha")(use)
    require("plugins.cmp")(use)
    require("plugins.colorizer")(use)
    require("plugins.comment")(use)
    require("plugins.ctags")(use)
    require("plugins.editorconfig")(use)
    require("plugins.fugitive")(use)
    require("plugins.fzf")(use)
    require("plugins.git")(use)
    require("plugins.gitsigns")(use)
    require("plugins.hop")(use)
    require("plugins.incsearch")(use)
    require("plugins.indentline")(use)
    require("plugins.lsp")(use)
    require("plugins.markdown_preview")(use)
    require("plugins.maximizer")(use)
    require("plugins.mundo")(use)
    require("plugins.numbertoggle")(use)
    require("plugins.ripgrep")(use)
    require("plugins.rsi")(use)
    require("plugins.startuptime")(use)
    require("plugins.tidy")(use)
    require("plugins.tree")(use)
    require("plugins.treesitter")(use)
    require("plugins.vimspector")(use)

    -- it conflicts with hop so needs to be laster initialized
    require("plugins.focus")(use)

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PackerBootstrap then
        require("packer").sync()
    end
end)
