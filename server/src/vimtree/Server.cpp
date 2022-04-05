#include "vimtree/StdinServer.hpp"

#include <iostream>

int main(int argc, char* argv[]) {
    if (argc != 2) {
        std::cout << "[0, {\"error\":\"pass cwd pl0x\"}]\n";
        return -1;
    }

    vimtree::StdinServer server(argv[1]);
    server.poll();
}
