#include "vimtree/StdinServer.hpp"

int main(int argc, char* argv[]) {

    vimtree::StdinServer server;
    server.poll();
}
