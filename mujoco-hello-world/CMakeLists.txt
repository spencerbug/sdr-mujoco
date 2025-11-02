cmake_minimum_required(VERSION 3.16)
project(mujoco_hello_world)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find MuJoCo installation
set(MUJOCO_DIR "${CMAKE_SOURCE_DIR}/../install" CACHE PATH "Path to MuJoCo installation")

# Set MuJoCo include and library paths
include_directories(${MUJOCO_DIR}/include)
link_directories(${MUJOCO_DIR}/lib)

# Add executable
add_executable(hello_world src/hello_world.cpp)

# Link against MuJoCo library
target_link_libraries(hello_world mujoco)

# Set RPATH so executable can find the shared library
set_target_properties(hello_world PROPERTIES
    BUILD_RPATH "${MUJOCO_DIR}/lib"
    INSTALL_RPATH "${MUJOCO_DIR}/lib"
)

# Install target
install(TARGETS hello_world DESTINATION bin)
