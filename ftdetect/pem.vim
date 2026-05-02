" vim-pki-zen filetype settings
if !get(g:, 'pkizen_enabled', 0) | finish | endif
"
if !executable('openssl')
  echoerr "Plugin 'vim-pki-zen' needs openssl - plugin will not be loaded"
  finish
endif
"
au BufRead,BufNewFile *.cer\|crt\|der\|pem   setlocal filetype=pem
au BufRead,BufNewFile * if getline(1) =~? 'BEGIN CERTIFICATE' | setlocal filetype=pem | endif

