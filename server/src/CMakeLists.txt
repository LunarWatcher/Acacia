set (SOURCE_FILES
    vimtree/Server.cpp
)

add_executable(treesitter ${SOURCE_FILES})

target_include_directories(treesitter PUBLIC ./)
target_include_directories(treesitter PUBLIC ${CONAN_INCLUDE_DIRS})

target_link_libraries(treesitter ${CONAN_LIBS})
