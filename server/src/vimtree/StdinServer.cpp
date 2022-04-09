#include "StdinServer.hpp"
#include "vimtree/VimInterface.hpp"

#include <nlohmann/json.hpp>

#include <string>
#include <fstream>
#include <functional>
#include <thread>

using namespace std::chrono_literals;

namespace vimtree {

StdinServer::StdinServer(const std::string& tsRoot) : runner(std::bind(&StdinServer::process, this)), interface(tsRoot) {
    interface.loadLanguage("cpp");
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
        std::flush(std::cout);
        trigger.wait(guard, [this]{ return tasks.size() > 0; });
    }

    if (!running) {
        error("Thread aborting");
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
        if (value.is_string() && value.get<std::string>() == "ping") {
            std::cout << "["  << id << ",\"pong\"]" << std::endl;
        } else {
            // we assume good requests; we now have an object.
            auto file = value.at("buff");

            interface.parse(value.at("filetype"), file);

        }

    }
}

}
