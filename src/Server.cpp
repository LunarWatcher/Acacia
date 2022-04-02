#include <iostream>

#include <spdlog/spdlog.h>
#include <spdlog/sinks/basic_file_sink.h>
#include <spdlog/sinks/stdout_color_sinks.h>

#include <fstream>
#include <nlohmann/json.hpp>

int main(int argc, char* argv[]) {

    std::string l;
    std::cout << "[0, \"started\"]" << std::endl;
        //std::cout << "[\"ex\", \"echoerr 'hi'\"]" << std::endl;
    while (true) {
        std::getline(std::cin, l);

        nlohmann::json j = nlohmann::json::parse(l);
        
        auto id = j.at(0).get<long long>();
        auto value = j.at(1);

        nlohmann::json r;

        if (value.is_string() && value == "ping") {
            r = "pong";
        }

        std::ofstream o("acacia.log", std::ios_base::app);
        o << l << std::endl;
        std::cout << "[" 
            << 0 << ","
            << value.dump()
            << "]" << std::endl;

    }
    std::cerr << "Server died." << std::endl;
}
