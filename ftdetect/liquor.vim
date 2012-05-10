autocmd BufNewFile,BufRead *.liquor set ft=liquor
autocmd BufNewFile,BufRead */_layouts/*.html set ft=liquor
autocmd BufNewFile,BufRead *.html,*.xml,*.markdown,*.textile
      \ if getline(1) == '---' | set ft=liquor | endif
