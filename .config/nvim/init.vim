source ~/.config/nvim/basics.vim
source ~/.config/nvim/navigation.vim
source ~/.config/nvim/folding.vim
source ~/.config/nvim/search.vim
source ~/.config/nvim/grep.vim
source ~/.config/nvim/indent.vim
source ~/.config/nvim/reflow.vim
for f in split(glob('~/.config/nvim/dotfiles/*.vim'), '\n')
    exe 'source' f
endfor
lua require('init')
