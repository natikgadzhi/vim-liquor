" Vim syntax file
" Language:     liquor
" Maintainer:   Nate Gadgibalaev <nat@evilmartians.com>
" Filenames:    *.liquor

if exists('b:current_syntax')
  finish
endif

if !exists('main_syntax')
  let main_syntax = 'liquor'
endif

if !exists('g:liquor_default_subtype')
  let g:liquor_default_subtype = 'html'
endif

if !exists('b:liquor_subtype') && main_syntax == 'liquor'
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
  exe 'runtime! syntax/'.b:liquor_subtype.'.vim'
  unlet! b:current_syntax
endif

syn case match

if exists('b:liquor_subtype') && b:liquor_subtype != 'yaml'
  " YAML Front Matter
  syn include @liquorYamlTop syntax/yaml.vim
  unlet! b:current_syntax
  syn region liquorYamlHead start="\%^---$" end="^---\s*$" keepend contains=@liquorYamlTop,@Spell
endif

if !exists('g:liquor_highlight_types')
  let g:liquor_highlight_types = []
endif

if !exists('s:subtype')
  let s:subtype = exists('b:liquor_subtype') ? b:liquor_subtype : ''

  for s:type in map(copy(g:liquor_highlight_types),'matchstr(v:val,"[^=]*$")')
    if s:type =~ '\.'
      let b:{matchstr(s:type,'[^.]*')}_subtype = matchstr(s:type,'\.\zs.*')
    endif
    exe 'syn include @liquorHighlight'.substitute(s:type,'\.','','g').' syntax/'.matchstr(s:type,'[^.]*').'.vim'
    unlet! b:current_syntax
  endfor
  unlet! s:type

  if s:subtype == ''
    unlet! b:liquor_subtype
  else
    let b:liquor_subtype = s:subtype
  endif
  unlet s:subtype
endif

syn region  liquorStatement  matchgroup=liquorDelimiter start="{%" end="%}" contains=@liquorStatement containedin=ALLBUT,@liquorExempt keepend
syn region  liquorExpression matchgroup=liquorDelimiter start="{{" end="}}" contains=@liquorExpression  containedin=ALLBUT,@liquorExempt keepend
syn region  liquorComment    matchgroup=liquorDelimiter start="{%\s*comment\s*%}" end="{%\s*endcomment\s*%}" contains=liquorTodo,@Spell containedin=ALLBUT,@liquorExempt keepend

syn cluster liquorExempt contains=liquorStatement,liquorExpression,liquorComment,@liquorStatement,liquorYamlHead
syn cluster liquorStatement contains=liquorConditional,liquorRepeat,liquorKeyword,@liquorExpression
syn cluster liquorExpression contains=liquorOperator,liquorString,liquorNumber,liquorFloat,liquorBoolean,liquorNull,liquorEmpty,liquorPipe,liquorForloop

syn keyword liquorKeyword highlight nextgroup=liquorTypeHighlight skipwhite contained
syn keyword liquorKeyword endhighlight contained
syn region liquorHighlight start="{%\s*highlight\s\+\w\+\s*%}" end="{% endhighlight %}" keepend

for s:type in g:liquor_highlight_types
  exe 'syn match liquorTypeHighlight "\<'.matchstr(s:type,'[^=]*').'\>" contained'
  exe 'syn region liquorHighlight'.substitute(matchstr(s:type,'[^=]*$'),'\..*','','').' start="{%\s*highlight\s\+'.matchstr(s:type,'[^=]*').'\s*%}" end="{% endhighlight %}" keepend contains=@liquorHighlight'.substitute(matchstr(s:type,'[^=]*$'),'\.','','g')
endfor
unlet! s:type

syn region liquorString matchgroup=liquorQuote start=+"+ end=+"+ contained
syn region liquorString matchgroup=liquorQuote start=+'+ end=+'+ contained
syn match liquorNumber "-\=\<\d\+\>" contained
syn match liquorFloat "-\=\<\d\+\>\.\.\@!\%(\d\+\>\)\=" contained
syn keyword liquorBoolean true false contained
syn keyword liquorNull null nil contained
syn match liquorEmpty "\<empty\>" contained

syn keyword liquorOperator and or not contained
syn match liquorPipe '|' contained skipwhite nextgroup=liquorFilter

syn keyword liquorFilter date capitalize downcase upcase first last join sort size strip_html strip_newlines newline_to_br replace replace_first remove remove_first truncate truncatewords prepend append minus plus times divided_by contained

syn keyword liquorConditional if elsif else endif unless endunless case when endcase ifchanged endifchanged contained
syn keyword liquorRepeat      for endfor tablerow endtablerow in contained
syn match   liquorRepeat      "\%({%\s*\)\@<=empty\>" contained
syn keyword liquorKeyword     assign cycle include with contained

syn keyword liquorForloop forloop nextgroup=liquorForloopDot contained
syn match liquorForloopDot "\." nextgroup=liquorForloopAttribute contained
syn keyword liquorForloopAttribute length index index0 rindex rindex0 first last contained

syn keyword liquorTablerowloop tablerowloop nextgroup=liquorTablerowloopDot contained
syn match liquorTablerowloopDot "\." nextgroup=liquorTableForloopAttribute contained
syn keyword liquorTablerowloopAttribute length index index0 col col0 index0 rindex rindex0 first last col_first col_last contained

hi def link liquorDelimiter             PreProc
hi def link liquorComment               Comment
hi def link liquorTypeHighlight         Type
hi def link liquorConditional           Conditional
hi def link liquorRepeat                Repeat
hi def link liquorKeyword               Keyword
hi def link liquorOperator              Operator
hi def link liquorString                String
hi def link liquorQuote                 Delimiter
hi def link liquorNumber                Number
hi def link liquorFloat                 Float
hi def link liquorEmpty                 liquorNull
hi def link liquorNull                  liquorBoolean
hi def link liquorBoolean               Boolean
hi def link liquorFilter                Function
hi def link liquorForloop               Identifier
hi def link liquorForloopAttribute      Identifier

let b:current_syntax = 'liquor'

if exists('main_syntax') && main_syntax == 'liquor'
  unlet main_syntax
endif
