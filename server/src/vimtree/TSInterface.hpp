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

    TSParser* parser;
public:
    TSInterface(const std::filesystem::path& tsRoot);
    ~TSInterface();

    // I think we want to do some caching here? Not sure how any of this works yet
    void parse(const std::string& language, const std::string& buffer);

    TSLanguage* loadLanguage(const std::string& language);
};

}
