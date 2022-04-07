#include "TSInterface.hpp"

#include "VimInterface.hpp"

#ifdef _WIN32
#include <windows.h>
#else
#include <dlfcn.h>
#endif

#include <iostream>

namespace vimtree {

TSInterface::TSInterface(const std::filesystem::path& tsRoot) : tsRoot(tsRoot) {
    parser = ts_parser_new();
}

TSInterface::~TSInterface() {
    for (auto& [l, loaderData] : loaders) {
#ifdef _WIN32
        // TODO: Cleanup
#else
        dlclose(loaderData.second);
#endif
    }

    ts_parser_delete(parser);
}

void TSInterface::parse(const std::string &language, const std::string &buffer) {
    auto tsLang = loadLanguage(language);
    error("Parsing buffer");
    if (!tsLang) {
        error(language + " not loaded.");
        return;
    }
    // Can I even reuse parsers like this?
    // We may also want to cache trees, but I have no idea how that'd work,
    // or how the performance might be affected.
    // Also seems like trees could be reused for different query types?
    ts_parser_set_language(parser, tsLang);

    TSTree* tree = ts_parser_parse_string(parser, nullptr, buffer.c_str(), buffer.size());
    TSNode root = ts_tree_root_node(tree);

    error("All good");
}

TSLanguage* TSInterface::loadLanguage(const std::string& language) {
    if (loaders.find(language) != loaders.end()) {
        return loaders[language].first;
    }
    std::string symbolCache = "tree_sitter_" + language;

    std::filesystem::path path = this->tsRoot / language / "libparser.so";
#ifdef _WIN32
    void* dhl = LoadLibrary(path.c_str());
#else
    void* dhl = dlopen(path.c_str(), RTLD_LAZY);
#endif

    if (dhl == nullptr) {
        error("[DYLoad] Critical error: failed to load " + path.string()
#ifndef _WIN32
                          + ": " + std::string(dlerror())
#endif
        );
        return nullptr;
    }

#ifdef _WIN32
    // An HMODULE is a void*, but the Windows API being absolute garbage prevents
    // an implicit cast from void* to a type that's void* :facepaw:
    // Fuck you Windows
    LanguageParser parser = (novamain_t) GetProcAddress((HMODULE) dhl, symbolCache.c_str());
    if (parser == nullptr) {
        error("failed to load " + symbolCache);
        return nullptr;
    }
#else
    dlerror();

    LanguageParser parser = (LanguageParser) dlsym(dhl, symbolCache.c_str());
    const auto err = dlerror();
    if (err) {
        error(std::string(err));
        return nullptr;
    }
#endif
    auto pInstance = parser();
    if (!pInstance) {
        error("Failed to load " + language);
        return nullptr;
    }
    loaders[language] = {pInstance, dhl};
    return pInstance;
}

}
