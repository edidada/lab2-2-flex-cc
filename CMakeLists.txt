cmake_minimum_required(VERSION 3.14)
project(lab2-2-flex-cc)

set(CMAKE_CXX_STANDARD 17)

# 查找工具
find_program(FLEX_EXECUTABLE flex REQUIRED)

if(APPLE)
    # 设置 flex 路径
    set(FLEX_HINT_PATHS /usr/local/opt/flex /opt/homebrew/opt/flex)

    # 查找 flex 的 include 目录
    find_path(FLEX_INCLUDE_DIR NAMES location.hh PATHS ${FLEX_HINT_PATHS} PATH_SUFFIXES include)
    find_library(FLEX_LIB NAMES fl PATHS ${FLEX_HINT_PATHS} PATH_SUFFIXES lib)

    if(FLEX_INCLUDE_DIR)
        include_directories(${FLEX_INCLUDE_DIR})
        message(STATUS "找到 Flex 头文件目录: ${FLEX_INCLUDE_DIR}")
    endif()

    if(FLEX_LIB)
        message(STATUS "找到 Flex 库: ${FLEX_LIB}")
    else()
        message(WARNING "未找到 Flex 库，尝试使用系统默认路径")
    endif()

    # 设置编译器标志
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -L/usr/local/opt/bison/lib")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -L/usr/local/opt/flex/lib")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -L/usr/local/opt/bison/lib -L/usr/local/opt/flex/lib")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -L/opt/homebrew/opt/flex/lib -L/opt/homebrew/opt/bison/lib")

elseif(UNIX AND NOT APPLE)
    message(STATUS "配置 Linux 环境")
    # Linux 下的配置
    # 通常 bison 会安装在标准路径，不需要特殊配置
    # 包含生成的头文件
endif()
# 源文件
set(LEXER_SOURCE flex/sysy.l)
# 生成文件
set(GENERATED_LEX_C ${CMAKE_CURRENT_BINARY_DIR}/lex.yy.cc)

# ==================== Flex 目标 ====================
add_custom_command(
        OUTPUT ${GENERATED_LEX_C}
        COMMAND ${FLEX_EXECUTABLE}
        -+
        --outfile=${GENERATED_LEX_C}
        ${CMAKE_CURRENT_SOURCE_DIR}/${LEXER_SOURCE}
        DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/${LEXER_SOURCE}
        COMMENT "Generating c++ lexer with flex"
)
add_executable(scanner
        ${GENERATED_LEX_C}
)

# ==================== 运行测试（可选）================
add_custom_target(run_test_cases_case1
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/scanner ${CMAKE_CURRENT_SOURCE_DIR}/test_cases/case_1.c
        DEPENDS scanner
        COMMENT "Running parser on test_cases/case1.sy"
)
