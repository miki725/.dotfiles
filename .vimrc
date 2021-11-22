source ~/.vim/basics.vim
source ~/.vim/navigation.vim
source ~/.vim/folding.vim
source ~/.vim/search.vim
source ~/.vim/grep.vim
source ~/.vim/indent.vim
source ~/.vim/reflow.vim
for f in split(glob('~/.vim/dotfiles/*.vim'), '\n')
    exe 'source' f
endfor
source ~/.vim/plugins/install.vim
source ~/.vim/plugins/config.vim
