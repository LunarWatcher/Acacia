#include "vimtree/StdinServer.hpp"
#include "vimtree/VimInterface.hpp"

#include <iostream>

int main(int argc, char* argv[]) {
    if (argc != 2) {
        std::cout << "[0, {\"error\":\"pass cwd pl0x\"}]\n";
        return -1;
    }
    try {
        vimtree::StdinServer server(argv[1]);
        server.poll();
    } catch(const std::exception& e) {
        std::cerr << e.what() << std::endl;
    } catch (...) {
        std::cerr << "Server died for unknown reasons" << std::endl;
    }
    vimtree::error("Stopped");
}
