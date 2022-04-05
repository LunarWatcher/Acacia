#include "TSInterface.hpp"

#ifdef _WIN32
#include <windows.h>
#else
#include <dlfcn.h>
#endif

#include <iostream>

namespace vimtree {

TSInterface::TSInterface(const std::filesystem::path& tsRoot) : tsRoot(tsRoot) {
    
}

TSInterface::~TSInterface() {
    for (auto& [l, loaderData] : loaders) {
#ifdef _WIN32
        // TODO: Cleanup
#else
        dlclose(loaderData.second);
#endif
    }
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
        std::cout << "[0, \"[DYLoad] Critical error: failed to load " + path.string()
#ifndef _WIN32
                          + ": " + std::string(dlerror())
#endif
            + "\"]";
        return nullptr;
    }

#ifdef _WIN32
    // An HMODULE is a void*, but the Windows API being absolute garbage prevents
    // an implicit cast from void* to a type that's void* :facepaw:
    // Fuck you Windows
    LanguageParser parser = (novamain_t) GetProcAddress((HMODULE) dhl, symbolCache.c_str());
    if (parser == nullptr) {
        std::cout << "[0, \"failed to load " + symbolCache + "\"]\n";
        return nullptr;
    }
#else
    dlerror();

    LanguageParser parser = (LanguageParser) dlsym(dhl, symbolCache.c_str());
    const auto err = dlerror();
    if (err) {
        std::cout << "[0, \"" + std::string(err) + "\"]\n";
        return nullptr;
    }
#endif
    auto pInstance = parser();
    if (!pInstance) {
        std::cout << "[0, \"failed to load " + language + "\"]\n";
        return nullptr;
    }
    loaders[language] = {pInstance, dhl};
    std::cout << "[0, \"successfully loaded " + language + "\"]\n";
    return pInstance;
}

}
