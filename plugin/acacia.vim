vim9script

# Semi-undocumented directory 
g:TreesitterDirectory = resolve(expand('<sfile>:p:h:h'))
g:TreesitterUpdateMode = 0


# TS management {{{
def acacia#UpdateTreesitter()
    if isdirectory(g:TreesitterDirectory .. '/tree-sitter')
        # TODO: enable the option to update to the newest tag?
        var resolvedUpdateMode = "echo 'Invalid update mode'"
        if (g:TreesitterUpdateMode == 0)
            resolvedUpdateMode = "git pull origin master && git checkout master"
        elseif  g:TreesitterUpdateMode == 1
            resolvedUpdateMode = "git checkout $(git describe --tags)"
        endif
        exec '!cd' g:TreesitterDirectory .. '/tree-sitter' '&&' resolvedUpdateMode
    else
        exec '!git clone https://github.com/tree-sitter/tree-sitter' g:TreesitterDirectory .. '/tree-sitter'
    endif
enddef

# }}}
# Command interface {{{
command! -nargs=0 TSUpdate call acacia#UpdateTreesitter()
# TODO: Hook up autocomplete
command! -nargs=1 TSInstall call acacia#Parsers#TSInstall(<f-args>)
command! -nargs=0 TSList call acacia#Parsers#TSList()
# }}}
