if exists("b:current_syntax")
  finish
endif

syn match smolDoctype "^\s*|\s*<!doctype\s\+html>"
syn match smolTagMarker "^\s*\zs%" conceal
syn match smolTag "^\s*%\zs[[:alnum:]_-]\+"
syn match smolTagBare "^\s*\zs[A-Za-z][[:alnum:]_-]*\ze\(\s\|[.#(]\|$\)"
syn match smolClass "\.[[:alnum:]_-]\+"
syn match smolId "#[[:alnum:]_-]\+"
syn match smolAttr "(\zs[^)]\+\ze)"
syn match smolFilter "^\s*:\(raw\|plain\)\>"
syn match smolSection "^\s*:\(head\|body\)\>"
syn match smolDirective "^\s*@\S\+"
syn match smolComment "^\s*-#.*$"
syn match smolPipe "^\s*\zs|\s" conceal
syn match smolCssProp "^\s\+[A-Za-z_][A-Za-z0-9_-]*\s*:" contains=smolCssValue
syn match smolCssVar "^\s\+--[A-Za-z0-9_-]*\s*:" contains=smolCssValue
syn match smolCssAt "^\s*@\S\+"

hi def link smolDoctype PreProc
hi def link smolTagMarker PreProc
hi def link smolTag Statement
hi def link smolTagBare Statement
hi def link smolClass Type
hi def link smolId Identifier
hi def link smolAttr String
hi def link smolFilter PreProc
hi def link smolSection PreProc
hi def link smolDirective PreProc
hi def link smolComment Comment
hi def link smolPipe PreProc
hi def link smolCssProp Type
hi def link smolCssVar Type
hi def link smolCssAt PreProc

let b:current_syntax = "smol"
