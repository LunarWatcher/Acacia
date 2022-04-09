#pragma once

#include "vimtree/TSInterface.hpp"
#include <nlohmann/json.hpp>

namespace vimtree {

class Module {
public:
    ~Module() = default;

    virtual void process(TSInterface& interface, const nlohmann::json& data, TSNode* root);

};

}
