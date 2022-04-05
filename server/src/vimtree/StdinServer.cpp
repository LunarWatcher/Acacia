#include "StdinServer.hpp"

#include <nlohmann/json.hpp>

#include <string>
#include <fstream>
#include <functional>
#include <thread>

namespace vimtree {

StdinServer::StdinServer() : runner(std::bind(&StdinServer::process, this)) {
    
}

StdinServer::~StdinServer() {
    running = false;
    trigger.notify_all();

    if (runner.joinable()) {
        runner.join();
    }
}

void StdinServer::poll() {

    while (running) {
        std::string line;
        std::getline(std::cin, line);

        dispatch(line);
    }
}

void StdinServer::dispatch(const std::string &line) {
    std::unique_lock<std::mutex> guard(lock);

    tasks.push(line);
    guard.unlock();
    trigger.notify_one();
}

std::string StdinServer::pop() {
    std::unique_lock<std::mutex> guard(lock);
    if (!tasks.size()) {
        trigger.wait(guard);
    }

    if (!running) {
        return "";
    }

    std::string t = tasks.front();
    tasks.pop();
    return t;
}

void StdinServer::process() {
    while (running) {
        std::string l = pop();
        if (!running) {
            // Server terminated while waiting
            break;
        }

        nlohmann::json j = nlohmann::json::parse(l);
        
        auto id = j.at(0).get<long long>();
        auto value = j.at(1);

        nlohmann::json r;
        if (value.is_string() && value == "ping") {
            r = "pong";
        } else {
            // we assume good requests; we now have an object.
            auto file = value.at("buff");
            r = file;
        }

        std::cout << "[" 
            << 0 << ","
            << r.dump()
            << "]" << std::endl;
    }
}

}
