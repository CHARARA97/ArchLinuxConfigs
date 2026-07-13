cmake_minimum_required(VERSION 3.14)
project(dvorak-practice VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# ── 查找依赖 ──
find_package(PkgConfig QUIET)
find_library(NCURSES_LIBRARY ncurses)
find_path(NCURSES_INCLUDE_DIR ncurses.h)

if(NOT NCURSES_LIBRARY OR NOT NCURSES_INCLUDE_DIR)
    message(FATAL_ERROR "ncurses library not found. Install with: sudo pacman -S ncurses")
endif()

# nlohmann_json (单头文件)
find_file(NLOHMANN_JSON_HEADER nlohmann/json.hpp
    PATHS /usr/include /usr/local/include
    NO_DEFAULT_PATH)

if(NOT NLOHMANN_JSON_HEADER)
    message(FATAL_ERROR "nlohmann-json not found. Install with: sudo pacman -S nlohmann-json")
endif()

# ── 源文件 ──
set(SOURCES
    src/main.cpp
    src/keyboard.cpp
    src/config.cpp
    src/wordlist.cpp
    src/practice.cpp
    src/statistics.cpp
    src/history.cpp
    src/ui_menu.cpp
    src/ui_practice.cpp
    src/ui_stats.cpp
)

# ── 可执行文件 ──
add_executable(dvorak-practice ${SOURCES})
target_include_directories(dvorak-practice PRIVATE
    ${NCURSES_INCLUDE_DIR}
    /usr/include
    src
)
target_link_libraries(dvorak-practice PRIVATE
    ${NCURSES_LIBRARY}
)

# ── 安装 ──
install(TARGETS dvorak-practice DESTINATION bin)
