#pragma once

#include <atomic>
#include <condition_variable>
#include <memory>
#include <mutex>
#include <thread>
#include <queue>

#include <iostream>
#include <utility>

#include <tree_sitter/api.h>


namespace vimtree {


class StdinServer {
private:
    std::thread runner;

    std::mutex lock;
    std::condition_variable trigger;

    std::queue<std::string> tasks;

    std::atomic<bool> running{true};
    std::vector<std::shared_ptr<TSParser>> parsers;
public:
    StdinServer();
    ~StdinServer();

    void poll();

    void process();

    void dispatch(const std::string& line);
    std::string pop(); 
};

}
