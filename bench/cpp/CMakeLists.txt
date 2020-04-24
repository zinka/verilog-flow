cmake_minimum_required(VERSION 3.0.0)
project(cmake_prj VERSION 0.1.0)

include(CTest)
enable_testing()

# # Download and unpack googletest at configure time
# configure_file(CMakeLists.txt.in googletest-download/CMakeLists.txt)
# execute_process(COMMAND ${CMAKE_COMMAND} -G "${CMAKE_GENERATOR}" .
#   RESULT_VARIABLE result
#   WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/googletest-download )
# if(result)
#   message(FATAL_ERROR "CMake step for googletest failed: ${result}")
# endif()
# execute_process(COMMAND ${CMAKE_COMMAND} --build .
#   RESULT_VARIABLE result
#   WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/googletest-download )
# if(result)
#   message(FATAL_ERROR "Build step for googletest failed: ${result}")
# endif()

# # Prevent overriding the parent project's compiler/linker
# # settings on Windows
# set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)

# # Add googletest directly to our build. This defines
# # the gtest and gtest_main targets.
# add_subdirectory(${CMAKE_CURRENT_BINARY_DIR}/googletest-src
#                  ${CMAKE_CURRENT_BINARY_DIR}/googletest-build
#                  EXCLUDE_FROM_ALL)

file(GLOB SOURCES
# "src/main.cpp"
"lib/*.cpp"
"src/*.cpp"
"/usr/share/verilator/include/verilated.cpp"
"/usr/share/verilator/include/verilated_vcd_c.cpp"
# "/usr/share/verilator/include/verilated_save.cpp"
# "/usr/share/verilator/include/verilated_dpi.cpp"
# "/usr/share/verilator/include/verilated_cov.cpp"
# "/usr/share/verilator/include/verilated_vpi.cpp"
)

# list(FILTER SOURCES EXCLUDE REGEX "main_thruwire.cpp")
list(FILTER SOURCES EXCLUDE REGEX "main_maskbus.cpp")
list(FILTER SOURCES EXCLUDE REGEX "main_blinky.cpp")
list(FILTER SOURCES EXCLUDE REGEX "main_ppsi.cpp")
list(FILTER SOURCES EXCLUDE REGEX "main_ppsii.cpp")
list(FILTER SOURCES EXCLUDE REGEX "main_ledwalker.cpp")
list(FILTER SOURCES EXCLUDE REGEX "main_reqwalker.cpp")
list(FILTER SOURCES EXCLUDE REGEX "main_helloworld.cpp")

add_executable(output ${SOURCES})
target_include_directories(output PRIVATE 
                           lib
                           src
                           /usr/share/verilator/include
                           /usr/share/verilator/include/vltstd
                           )

# target_link_libraries(output gtest_main)
# add_test(NAME example_test COMMAND example)

set(CPACK_PROJECT_NAME ${PROJECT_NAME})
set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})
include(CPack)