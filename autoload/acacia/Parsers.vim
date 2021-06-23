vim9script

g:AcaciaParsers = {
    'cpp': {
        'url': 'https://github.com/tree-sitter/tree-sitter-cpp',
        'files': [ "src/parser.c", "src/scanner.cc" ]
    }
}


def acacia#Parsers#TSManage(language: string, install: number = 1)
    if !has_key(g:AcaciaParsers, 'language')
        echo "Failed to find" language "on the list of supported languages."
        return
    endif 
    var directoryExists = isdirectory(g:TreesitterDirectory .. '/parsers/' .. language)

    if install

    else
        if (!directoryExists)
            echo "Parser not installed"
            return
        endif

    endif

enddef

def acacia#Parsers#TSList()
    echo "The supported languages are:" keys(g:AcaciaParsers)->join(', ')
enddef
