// I'm not sure if a main class is necessary, or if using dlopen is cheaper.
// Using a server is probably better, though, to prevent unnecessary re-opening
// of any potential tree-sitter things.
#include <iostream>

int main() {
    std::cout << "Compiling successful" << std::endl;
}
