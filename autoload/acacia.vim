vim9script

g:TreesitterParsers = {
    'cpp': {
        'url': 'https://github.com/tree-sitter/tree-sitter-cpp',
        'files': [ "src/parser.c", "src/scanner.cc" ]
    }
}

# Semi-undocumented directory variable
g:TreesitterDirectory = resolve(expand('<sfile>:p:h:h'))
g:TreesitterOnline = 0

if !exists('g:TreesitterCompiler')
    g:TreesitterCompiler = $CC
    if g:TreesitterCompiler == ""
        if has("win32")
            g:TreesitterCompiler = "cl"
        else
            g:TreesitterCompiler = "gcc"
        endif
    endif
endif

var job: job
var channel: channel

export def TSIOInput(ch: channel, msg: any)
    echom msg
    if (msg == "pong")
        g:TreesitterOnline = 1
    endif
enddef

export def TSInit()
    job = job_start(g:TreesitterDirectory .. "/server/build/bin/treesitter",
        {
            "callback": TSIOInput,
            "mode": "json",
            "noblock": 1,
            "timeout": 0
        }
    )
    if job->job_status() == "fail"
        echoerr "Failed to start server."
    endif

    channel = job->job_getchannel()
    channel->ch_evalexpr("ping")

enddef

export def TSManage(language: string, install: number = 1)
    if !has_key(g:TreesitterParsers, language)
        echo "Failed to find" language "on the list of supported languages."
        return
    endif

    var targetDirectory = fnameescape(g:TreesitterDirectory .. '/parsers/' .. language)
    var directoryExists = isdirectory(targetDirectory)

    if install
        if (directoryExists)
            echo "Updating parser..."
            # These are executed in a subprocess,
            # so we don't need to worry about pwd management
            exec '!cd' targetDirectory "&& git pull"
        else
            exec '!git clone' g:TreesitterParsers[language].url targetDirectory
        endif
        
        # Now we compile

        var compiler = g:TreesitterCompiler

        var baseArgs: list<string> = [] #"src/parser.c src/scanner.cc"
        var cArgs: list<string>    = []
        var cppArgs: list<string>  = []
        if has("win32")
            echoerr "Not supported; open a PR or wait for me to maybe or maybe not do it"
            return
        else
            #baseArgs->add("-Isrc/")
            baseArgs->add("-fPIC")

            cppArgs = baseArgs->copy()

            cArgs = baseArgs->copy()
            cppArgs->add("-std=c++14")
            cppArgs->add("-llibc++")

            cArgs->add("-std=c99")
        endif

        var cAppend = cArgs->join(" ")
        var cppAppend = cppArgs->join(" ")

        var cFiles = globpath(targetDirectory .. "/src", '*.c')->split('\n')
        var cppFiles = globpath(targetDirectory .. "/src", '*.cc')->split('\n')

        # These appear to be standard
        var compArg = ""

        for cF in cFiles
            var base = cF[0 : cF->stridx(".") - 1]
            compArg ..= " && "
                .. compiler
                .. " " .. cF
                .. " -o " .. base .. ".o -c "
                .. cAppend
        endfor

        for cF in cppFiles
            var base = cF[0 : cF->stridx(".") - 1]
            compArg ..= " && "
                .. compiler
                .. " " .. cF
                .. " -o " .. base .. ".o -c "
                .. cppAppend
        endfor

        echo "Compiling objects..."
        var logs = system("cd " .. targetDirectory .. " " .. compArg)
        if v:shell_error != 0
            echoerr logs
            echoerr "Failed to compile parser"
            return
        endif

        echo "Compiling parser.so..."
        var objects = globpath(targetDirectory .. "/src", '*.o')->split('\n')
        logs = system("cd " .. targetDirectory .. " && " .. compiler .. " " .. objects->join(' ') .. " -shared -o parser.so")
        if v:shell_error != 0
            echoerr logs
            echoerr "Failed to compile parser"
            return
        endif
        echo "Compilation successful."
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

export def TSList()
    echo "The supported languages are:" keys(g:TreesitterParsers)->join(', ')
enddef

# Building the server {{{
export def BuildServer()
    # if mkdir -p is bad on Windows, this is a Windows blocker
    echo system('cd ' .. g:TreesitterDirectory .. '/src && mkdir -p build && cd build && cmake .. && cmake --build . -j 4')
enddef
# }}}
# Runner {{{

export def TSRefresh()
    if g:TreesitterOnline == 0
        return
    endif

    channel->ch_evalexpr({"buff": join(getline(1, "$"), "\n")})
enddef

export def InitializeBuffer()
    if has_key(g:TreesitterParsers, &ft)
        autocmd CursorHoldI <buffer> call acacia#TSRefresh()
    endif
enddef

export def TSStop()
    job->job_stop()
    g:TreesitterOnline = 0
enddef

export def TSRestart()
    TSStop()
    TSInit()
enddef

# }}}
