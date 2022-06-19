map , <leader>
noremap <silent> zzz :q!<CR>
noremap :jq :%!jq '.'<CR>

noremap <F10> :<C-u>sp<CR>:e<Space>~/dotfiles/vimrc/command<CR>
noremap <silent> rr <Cmd>source<Space>$MYVIMRC<CR><Cmd>echo<Space>"Reload .vimrc!"<CR>

nnoremap <C-w>n gt
nnoremap <C-w>p gT
nnoremap <C-w>o <C-w>_<C-w>\|
nnoremap <C-w>t :<C-u>tabnew<CR>
nnoremap <C-w>s :<C-u>sp<CR>
nnoremap <C-w>v :<C-u>vs<CR>

nnoremap あ a
nnoremap い i
nnoremap う u
nnoremap お o
nnoremap っd dd
