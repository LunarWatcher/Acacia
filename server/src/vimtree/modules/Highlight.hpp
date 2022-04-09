#pragma once

#include "Module.hpp"

namespace vimtree {

class Highlight : public Module {
public:
    void process(TSInterface& i, const nlohmann::json& data, TSNode* root) override;
};

}
