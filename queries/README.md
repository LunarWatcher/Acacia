# Queries

The various queries drive the core of tree-sitter, and is the only way it works.

However, because I have 0 idea what I'm doing, and I don't have time to write queries for every single supported language, this directory currently contains symlinks to nvim-treesitter's queries. This isn't really great in the long run; as Vim and Nvim continue to diverge, the chances the queries break here get higher. The long-term goal is to get rid of the symlinks and write the queries from scratch, but it's not feasible for me to be stuck with 107 languages to write queries for when I don't even have anything to use it on.

Consequently, they'll be used for the near foreseeable future, with a goal of eventually being replaced.

Note that 

<sub>Obligatory license note that the queries from nvim-treesitter are licensed under [Apache 2.0](https://github.com/nvim-treesitter/nvim-treesitter/blob/c04aa172a3feab61f8f4fbfa0e3d47fa12513485/LICENSE), and aren't the work of this repo; see the linked license file for more details. This applies to all the queries retrieved through symlinks. Any non-symlink queries, unless otherwise noted, are a part of this project, and fall under the MIT license instead. See the LICENSE file at the root of this repo for the full license text for those files</sub>
