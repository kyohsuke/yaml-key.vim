# yaml-key.vim
今の階層のキーをドットでつないで表示するマン

```<Leader>f``` で今カーソルのある場所のキーを表示します (ドット区切り)

## require

* python3

## configs

* g:yamlkey_and_yank : default 1  
  detected yaml key set to yank buffer.  
  if it set to 0, yaml key not to set yank buffer

* g:yamlkey_first_symbol : default '.'  
  yaml key first symbol

* g:yamlkey_separator : default '.'  
  yaml key separator
