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
    if (type(msg) == v:t_string && msg == "pong")
        g:TreesitterOnline = 1
    elseif (type(msg) == v:t_dict)
        if msg->has_key("error")
            # Temporary error management
            echom msg
        endif
    else
        # Temporary generic catch-all
        echom msg
    endif
enddef

export def TSInit()
    job = job_start(g:TreesitterDirectory .. "/server/build/bin/treesitter " .. g:TreesitterDirectory .. "/parsers/",
        {
            "callback": TSIOInput,
            "mode": "json",
            "err_mode": "raw",

            "noblock": 1,
            "timeout": 20
        }
    )
    if job->job_status() == "fail"
        echoerr "Failed to start server."
        return
    endif

    channel = job->job_getchannel()
    channel->ch_sendexpr("ping", {'callback': TSIOInput})
enddef

export def TSManage(language: string, install: number = 1)
    if !has_key(g:TreesitterParsers, language)
        echo "Failed to find" language "on the list of supported languages."
        return
    endif

    var targetDirectory = fnameescape(g:TreesitterDirectory .. '/parsers/' .. language)
    var directoryExists = isdirectory(targetDirectory)

    if install
        var logs: string
        if (directoryExists)
            echo "Updating parser..."
            # These are executed in a subprocess,
            # so we don't need to worry about pwd management
            logs = system('cd' .. " " .. targetDirectory .. " && git pull")
        else
            echo "Cloning directory..."
            logs = system('git clone' .. " " .. g:TreesitterParsers[language].url .. " " .. targetDirectory)
        endif
        if v:shell_error
            echoerr logs
            echoerr "Failed to clone directory"
            return
        endif
        echo "Directory grabbed. Compiling..."
        
        # Now we compile

        var lines = readfile(g:TreesitterDirectory .. "/scripts/CMakeLists.txt")
        writefile(lines, targetDirectory .. "/CMakeLists.txt")
        var res = system("cd " .. targetDirectory .. " && cmake . && cmake --build .")->split('\n')
        if v:shell_error
            for l in res
                echoerr l
            endfor
            echoerr "Failed to compile."
            return
        endif
        echo "Succssfully installed parser for" language
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

    channel->ch_evalexpr({"buff": join(getline(1, "$"), "\n"), "filetype": &ft})
enddef

export def InitializeBuffer()
    # TODO: deal with installed parsers too
    if !g:TreesitterParsers->has_key(&ft)
        return
    endif
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

export def TSStatus()
    echo job_info(job)
enddef

# }}}
