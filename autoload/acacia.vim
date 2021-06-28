vim9script

g:TreesitterParsers = {
    'cpp': {
        'url': 'https://github.com/tree-sitter/tree-sitter-cpp',
        'files': [ "src/parser.c", "src/scanner.cc" ]
    }
}

# Semi-undocumented directory variable
g:TreesitterDirectory = resolve(expand('<sfile>:p:h:h'))

def acacia#TSManage(language: string, install: number = 1)
    if !has_key(g:TreesitterParsers, language)
        echo "Failed to find" language "on the list of supported languages."
        return
    endif

    var targetDirectory = fnameescape(g:TreesitterDirectory .. '/parsers/' .. language)
    var directoryExists = isdirectory(targetDirectory)

    if install
        if (directoryExists)
            echo "Parser already installed"
            return
        endif

        exec '!git clone' g:TreesitterParsers[language].url targetDirectory
    else
        if (!directoryExists)
            echo "Parser not installed"
            return
        endif
        if delete(targetDirectory, 'rf') != 0
            echo "delete() reported an error when trying to remove the parser"
        else
            echo "Parser successfully removed."
        endif
    endif

enddef

def acacia#TSList()
    echo "The supported languages are:" keys(g:TreesitterParsers)->join(', ')
enddef

# Building the server {{{
def acacia#BuildServer()
    # if mkdir -p is bad on Windows, this is a Windows blocker
    echo system('cd ' .. g:TreesitterDirectory .. '/src && mkdir -p build && cd build && cmake .. && cmake --build . -j 4')
enddef
# }}}
# Runner {{{
def acacia#InitializeBuffer()
    if has_key(g:TreesitterParsers, &ft)
        # Do some fancy initialization or whatever
    endif
enddef
# }}}
