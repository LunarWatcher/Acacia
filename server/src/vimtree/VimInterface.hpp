#pragma once

#include <string>
#include <nlohmann/json.hpp>

#include <iostream>

namespace vimtree {

inline void escape(std::string& raw) {
    size_t idx = 0;
    while ((idx = raw.find("\"", idx)) != std::string::npos) {
        raw.replace(idx, 1, "\\\"");
        idx += 2;
    }
}

inline void error(std::string msg) {
    escape(msg);
    std::cout << "[0, {\"error\": \"" + msg + "\"}]" << std::endl;
}

}
