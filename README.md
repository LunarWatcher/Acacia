# Acacia

Treesitter for Vim.

Note that I'm currently the only person working on this, with a fairly low chance of ending up with other maintainers (due to a lack of interest in meta development, mostly). There's no guarantees wrt. stability or functionality at this time, nor is there a concrete roadmap for when stuff is scheduled to be done. If you're interested in seeing tree-sitter support in Vim, please consider contributing to something on the [TODO list](https://github.com/LunarWatcher/Acacia/issues/1)

See the help document for the more technical sides.

## Requirements

See the help document for more detailed requirements

* Modern Vim (needs Vim 9 support - 8.2.2717 should generally be supported, though earlier may be fine)
* C++17 compiler
    * ... and Python 3 with Conan
* CMake 3.10 or higher
* C compiler
* Rust compiler (it's unclear whether this is necessary or not at the time of writing)
* Linux or Mac; see the bugs section in the help document for a list of problems potentially preventing Windows compatibility at this time (contributions wanted when the project progresses that far)

## A note on queries

For the time being, this plugin will be piggy-backing off nvim-treesitter queries. This is largely because I don't have the time or language skills to write queries for all the applicable languages. If this plugin eventually gains some traction in the Vim community, however, the dependency on nvim-treesitter will be reconsidered. For the near foreseeable future, the goal is to get the plugin universally operational, which means piggy-backing on nvim-treesitter is a necessity.

