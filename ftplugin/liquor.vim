" Vim filetype plugin
" Language:     liquor
" Maintainer:   Nate Gadgibalaev <nat@evilmartians.com>

if exists('b:did_ftplugin')
  finish
endif

if !exists('g:liquor_default_subtype')
  let g:liquor_default_subtype = 'html'
endif

if !exists('b:liquor_subtype')
  let s:lines = getline(1)."\n".getline(2)."\n".getline(3)."\n".getline(4)."\n".getline(5)."\n".getline("$")
  let b:liquor_subtype = matchstr(s:lines,'liquor_subtype=\zs\w\+')
  if b:liquor_subtype == ''
    let b:liquor_subtype = matchstr(&filetype,'^liquor\.\zs\w\+')
  endif
  if b:liquor_subtype == ''
    let b:liquor_subtype = matchstr(substitute(expand('%:t'),'\c\%(\.liquor\)\+$','',''),'\.\zs\w\+$')
  endif
  if b:liquor_subtype == ''
    let b:liquor_subtype = g:liquor_default_subtype
  endif
endif

if exists('b:liquor_subtype') && b:liquor_subtype != ''
  exe 'runtime! ftplugin/'.b:liquor_subtype.'.vim ftplugin/'.b:liquor_subtype.'_*.vim ftplugin/'.b:liquor_subtype.'/*.vim'
else
  runtime! ftplugin/html.vim ftplugin/html_*.vim ftplugin/html/*.vim
endif
let b:did_ftplugin = 1

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|'
else
  let b:undo_ftplugin = ''
endif
if exists('b:browsefilter')
  let b:browsefilter = "\n".b:browsefilter
else
  let b:browsefilter = ''
endif
if exists('b:match_words')
  let b:match_words .= ','
elseif exists('loaded_matchit')
  let b:match_words = ''
endif

if has('gui_win32')
  let b:browsefilter="liquor Files (*.liquor)\t*.liquor" . b:browsefilter
endif

if exists('loaded_matchit')
  let b:match_words .= '\<\%(if\w*\|unless\|case\)\>:\<\%(elsif\|else\|when\)\>:\<end\%(if\w*\|unless\|case\)\>,\<\%(for\|tablerow\)\>:\%({%\s*\)\@<=empty\>:\<end\%(for\|tablerow\)\>,<\(capture\|comment\|highlight\)\>:\<end\1\>'
endif

setlocal commentstring={%\ comment\ %}%s{%\ endcomment\ %}

let b:undo_ftplugin .= 'setl cms< | unlet! b:browsefilter b:match_words'
