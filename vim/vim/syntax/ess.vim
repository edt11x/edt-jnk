" Vim ESS syntax file
"    Language: MTE ESS Log File
"    Revision: 1.0
"  Maintainer: Ed Thompson
" Last Change: 2010 Mar 31

" For version  < 6.0: Clear all syntax items
" For version >= 6.0: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Always ignore case
syn case ignore


"
syn match   essError    "\sFAIL\s"
syn match   essError    "\(\S*f \|\S*f$\|429\d\d\d\d\d\d\d\|\(pppp\)\@![pf][pf][pf][pf]\)"
syn match   PowerCycle  "Power Cycle"

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_ess_syntax_inits")
  if version < 508
    let did_ess_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink essError          Error
  HiLink PowerCycle        Special
"  HiLink abapComment        Comment
"  HiLink abapInclude        Include
"  HiLink abapSpecial        Special
"  HiLink abapSpecialTables  PreProc
"  HiLink abapSymbolOperator abapOperator
"  HiLink abapOperator       Operator
"  HiLink abapStatement      Statement
"  HiLink abapString         String
"  HiLink abapFloat          Float
"  HiLink abapNumber         Number
"  HiLink abapHex            Number

  delcommand HiLink
endif

let b:current_syntax = "ess"


