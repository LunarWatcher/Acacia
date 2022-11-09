This project has stalled as interests have shifted. Additionally, Bram is [looking at the TextMate grammar system](https://github.com/vim/vim/issues/9087), and his argument against Tree-sitter (notably not requiring the user to be able to compile C) makes a ton of sense. The modular compilation process has remained a bottleneck for me while trying to get this plugin working. Anyway, it doesn't really matter, because this project was started with the idea that nothing similar to TextMate/Tree-sitter/etc would become relevant soon enough for this plugin to not do stuff:tm:. That no longer holds.

Any extended syntax highlighting features solve what I wanted to accomplish here. While nothing has been implemented yet, it's being looked at, with the intent of having first-class support; I cannot compete with that in a plugin. Consequently, this project is now abandoned in favor of future (but near future) improvements to Vim itself.

# Acacia

Treesitter for Vim.

Note that I'm currently the only person working on this, with a fairly low chance of ending up with other maintainers (due to a lack of interest in meta development, mostly). There's no guarantees wrt. stability or functionality at this time, nor is there a concrete roadmap for when stuff is scheduled to be done. If you're interested in seeing tree-sitter support in Vim, please consider contributing to something on the [TODO list](https://github.com/LunarWatcher/Acacia/issues/1)

See the help document for the more technical sides.

## Requirements

See the help document for more detailed requirements

* Modern Vim (needs Vim 9 support - 8.2.2717 should generally be supported, though earlier may be fine)
* C++17 compiler
    * ... and Python 3 with Conan
* CMake 3.10 or newer
* C compiler
* Linux or Mac; see the bugs section in the help document for a list of problems potentially preventing Windows compatibility at this time (contributions wanted when the project progresses that far)

## A note on queries

For the time being, this plugin will be piggy-backing off nvim-treesitter queries. This is largely because I don't have the time or language skills to write queries for all the applicable languages. If this plugin eventually gains some traction in the Vim community, however, the dependency on nvim-treesitter will be reconsidered. For the near foreseeable future, the goal is to get the plugin universally operational, which means piggy-backing on nvim-treesitter is a necessity.

