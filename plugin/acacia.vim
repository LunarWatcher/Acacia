vim9script

# Command interface {{{
command! -nargs=0 TSUpdate call acacia#UpdateTreesitter()
# TODO: Hook up autocomplete
command! -nargs=1 TSInstall call acacia#TSManage(<f-args>, 1)
command! -nargs=0 TSList call acacia#TSList()
# }}}
# Runner {{{
augroup AcaciaGroup1
    au!
    autocmd FileType * call acacia#InitializeBuffer()
augroup END
# }}}
