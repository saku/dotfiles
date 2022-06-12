if executable('rg')
  function! FZGrep(query, fullscreen)
    let command_fmt = 'rg --fixed-strings --smart-case --column --line-number --no-heading --hidden --follow --glob "!.git/*" --color=always -- %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
    call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
  endfunction

  noremap fzf :GFiles<CR>
  nnoremap <silent> <leader>ss :RG<CR>
  nnoremap <silent> <leader>si :call FZGrep(expand("<cfile>"), 0)<cr>
  vnoremap <silent> <leader>ss :call FZGrep(GetSelectionText(), 0)<cr>
  command! -nargs=* -bang RG call FZGrep(<q-args>, <bang>0)
endif
