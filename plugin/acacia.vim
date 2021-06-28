vim9script

if exists('g:_acacia_loaded')
    finish
endif
g:_acacia_loaded = 1

# Command interface {{{

# TODO: Hook up autocomplete To these two
command! -nargs=1 TSInstall call acacia#TSManage(<f-args>, 1)
command! -nargs=1 TSUninstall call acacia#TSManage(<f-args>, 0)

command! -nargs=0 TSList call acacia#TSList()
# }}}
# Runner {{{
augroup AcaciaGroup1
    au!
    autocmd FileType * call acacia#InitializeBuffer()
augroup END
# }}}
