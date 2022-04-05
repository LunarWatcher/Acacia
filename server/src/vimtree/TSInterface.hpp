#pragma once

#include <string>
#include <filesystem>
#include <map>

#include "tree_sitter/api.h"

namespace vimtree {

typedef TSLanguage* (*LanguageParser)(void);

class TSInterface {
private:
    const std::filesystem::path tsRoot;

    std::map<std::string, std::pair<TSLanguage*, void*>> loaders;

public:
    TSInterface(const std::filesystem::path& tsRoot);
    ~TSInterface();

    TSLanguage* loadLanguage(const std::string& language);
};

}
