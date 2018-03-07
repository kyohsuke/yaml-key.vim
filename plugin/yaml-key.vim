" vim:set foldmethod=marker:
"=============================================================================
" File: yaml-key.vim
" Author: Keisuke Kawhara
" Created: 2018-03-06
"=============================================================================

scriptencoding utf-8

if exists('g:loaded_yaml_key')
    finish
endif
let g:loaded_yaml_key = 1

if !exists("g:yamlkey_and_yank") || !g:yamlkey_and_yank
  let g:yamlkey_and_yank = 1
endif

let s:save_cpo = &cpo
set cpo&vim

function! s:FetchYamlKey()
    let ft = &filetype
    let result = ''
python << EOF
import vim
import re

def execute():
    file_type = vim.eval("l:ft")
    if file_type != 'yaml':
        return

    bufnum, lnum, col, off = vim.eval('getpos(".")')
    keys = []
    indent = 999
    lnum = int(lnum)

    check_line = lnum - 1
    if 0 <= check_line and len(vim.current.buffer[check_line].strip()) == 0:
        return
    for line in reversed(range(lnum)):
        curr = vim.current.buffer[line]
        result = re.search('\w+:', curr)
        if result is not None and result.start() < indent:
            indent = result.start()
            keys.append(result.group()[0:-1])
        if indent == 0:
            break

    result_key = '.{}'.format('.'.join(reversed(keys))) if 0 < len(keys) else ''
    vim.command("let result='{}'".format(result_key))
execute()
EOF
    return result
endfunction

function! s:ShowYamlKey()
  let result = s:FetchYamlKey()
  if g:yamlkey_and_yank
    let @+ = result
  endif
  echo result
endfunction

nnoremap <Plug>ShowYamlKey :<C-u>call <SID>ShowYamlKey()<CR>
nnoremap <Plug>FetchYamlKey :<C-u>call <SID>FetchYamlKey()<CR>

if !exists("g:yamlkey_no_mappings") || !g:yamlkey_no_mappings
  nmap <Leader>f <Plug>ShowYamlKey
endif

let &cpo = s:save_cpo
unlet s:save_cpo
