set (SOURCE_FILES
    vimtree/Server.cpp
    vimtree/StdinServer.cpp
    vimtree/TSInterface.cpp
)

add_executable(treesitter ${SOURCE_FILES})

target_include_directories(treesitter PUBLIC ./)
target_include_directories(treesitter PUBLIC ${CONAN_INCLUDE_DIRS})

target_link_libraries(treesitter PUBLIC ${CONAN_LIBS})

if (NOT WIN32)
    target_link_libraries(treesitter PUBLIC dl)
endif()
