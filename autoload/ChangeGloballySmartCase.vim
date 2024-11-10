" ChangeGloballySmartCase.vim: Change {motion} text and repeat as SmartCase substitution.
"
" DEPENDENCIES:
"   - ChangeGlobally.vim plugin
"   - ingo-library.vim plugin
"   - SmartCase.vim plugin (SmartCase() function)
"
" Copyright: (C) 2012-2019 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
let s:save_cpo = &cpo
set cpo&vim

function! s:SmartReplace( newText ) abort
    return (a:newText ==# submatch(0) ?
    \   a:newText :
    \   (empty(a:newText) ?
    \       '' :
    \       SmartCase(a:newText)
    \   )
    \)
endfunction
function! ChangeGloballySmartCase#CountedReplace() abort
    return s:SmartReplace(ChangeGlobally#CountedReplace())
endfunction
function! ChangeGloballySmartCase#AreaReplaceSecondPass() abort
    return s:SmartReplace(ChangeGlobally#AreaReplaceSecondPass())
endfunction
function! ChangeGloballySmartCase#Hook( search, replace, ... ) abort
    " Use a case-insensitive match (prepend \c, as the hook doesn't allow to
    " append the /i flag to the :substitute command).
    let l:search = '\c' . substitute(a:search, '\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!\\c', '', 'g')

    let l:replace = a:replace
    " Change moved-over text / selection globally.
    let l:replace = substitute(l:replace, '\CChangeGlobally#CountedReplace', 'ChangeGloballySmartCase#CountedReplace', '')
    " Change current word / WORD / selection / moved-over text over the moved-over area.
    let l:replace = substitute(l:replace, '\CChangeGlobally#AreaReplaceSecondPass', 'ChangeGloballySmartCase#AreaReplaceSecondPass', '')

    " The substitution separator is /; therefore, the escaped form (\/) must be
    " converted, too.
    return ['\V' . ingo#smartcase#FromPattern(l:search, '/'), l:replace]
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
