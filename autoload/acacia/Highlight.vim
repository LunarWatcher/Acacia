vim9script

# There are better ways to structure this, but this is a hack to get the
# ball rolling.
# Vim9 classes could be applicable, but basic functions do the trick as
# well. Doesn't have to be fancy if it's functional and fast.

# Syntax helpers {{{

# I'm going out on a limb and assuming highlights don't span multiple lines.
# if they do, parts here need to be redesigned to use end_lnum and end_col
def HighlightRange(bufID, line, startCol, length, hlGroup)
    
    prop_add(line, startCol, {
        'bufnr': bufID,
        'length': length
    })
enddef

# }}}
# Treesitter runner {{{

# TODO

# }}}
