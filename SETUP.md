# MuJoCo Setup Documentation

This document details the complete setup process for compiling MuJoCo from source and creating a basic "hello world" program.

## System Information

- **OS**: Linux (Ubuntu 24.04)
- **Date**: November 2, 2025
- **MuJoCo Version**: 3.3.8

## Prerequisites

### System Dependencies (via apt)

The following packages were installed via `apt-get`:

```bash
sudo apt-get update
sudo apt-get install -y \
    cmake \
    build-essential \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libglfw3-dev \
    libxinerama-dev \
    libxcursor-dev \
    libxi-dev \
    libxkbcommon-dev
```

**Package Summary:**
- `cmake` (3.28.3+) - Build system
- `build-essential` - GCC/G++ compiler toolchain
- `libgl1-mesa-dev` - OpenGL development files
- `libglu1-mesa-dev` - OpenGL utility library
- `libglfw3-dev` - GLFW library for window/input management
- `libxinerama-dev`, `libxcursor-dev`, `libxi-dev` - X11 extensions
- `libxkbcommon-dev` - Keyboard handling library (required by GLFW)

## Building MuJoCo from Source

### Quick Start (Automated)

The easiest way to build MuJoCo is using the provided build script:

```bash
cd /root/sdr-mujoco
./build_mujoco.sh
```

This script will:
1. Install all required system dependencies via apt
2. Configure the build with CMake
3. Compile MuJoCo with all CPU cores
4. Install to `/root/sdr-mujoco/install`

**Script Options:**
```bash
./build_mujoco.sh [OPTIONS]

Options:
  -s, --skip-deps       Skip system dependency installation
  -c, --clean           Clean build directory before building
  -d, --debug           Build in Debug mode instead of Release
  -j, --jobs N          Number of parallel jobs (default: nproc)
  -v, --verbose         Verbose output
  -h, --help            Show help message
```

**Examples:**
```bash
# Standard build
./build_mujoco.sh

# Clean rebuild
./build_mujoco.sh --clean

# Skip dependency installation (if already done)
./build_mujoco.sh --skip-deps

# Debug build with verbose output
./build_mujoco.sh --debug --verbose
```

### Manual Build (Alternative)

If you prefer to build manually or need more control:

#### 1. Clone the Repository

The repository was already cloned at `/root/sdr-mujoco/mujoco`.

#### 2. Install System Dependencies

```bash
sudo apt-get update
sudo apt-get install -y \
    cmake \
    build-essential \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libglfw3-dev \
    libxinerama-dev \
    libxcursor-dev \
    libxi-dev \
    libxkbcommon-dev
```

#### 3. Configure the Build

```bash
cd /root/sdr-mujoco
mkdir -p build
cd build
cmake ../mujoco \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/root/sdr-mujoco/install
```

**CMake Options Explained:**
- `-DCMAKE_BUILD_TYPE=Release` - Optimized build for performance
- `-DCMAKE_INSTALL_PREFIX` - Installation directory for compiled binaries and libraries

#### 4. Compile

```bash
cmake --build . -j$(nproc)
```

This uses all available CPU cores for faster compilation. The build process took approximately 5-10 minutes and compiled:
- Core MuJoCo library (`libmujoco.so`)
- Sample programs (`simulate`, `basic`, `compile`, etc.)
- Test suites
- Plugins (actuator, sensor, SDF, elasticity)

#### 5. Install

```bash
cmake --install .
```

### Installation Structure

This installs to `/root/sdr-mujoco/install` with the following structure:
```
install/
├── bin/           # Executables (simulate, basic, etc.)
├── include/       # Header files
│   ├── mujoco/   # Main MuJoCo headers
│   └── simulate/ # Simulate library headers
├── lib/          # Libraries
│   ├── libmujoco.so.3.3.8
│   ├── libmujoco.so -> libmujoco.so.3.3.8
│   └── cmake/    # CMake configuration files
└── share/        # Model files and examples
    └── mujoco/
        └── model/
```

## Directory Structure (Following MuJoCo Documentation)

Based on the [official MuJoCo programming guide](https://mujoco.readthedocs.io/en/stable/programming/index.html), we created the following project structure:

```
mujoco-hello-world/
├── bin/           # Compiled executables (output directory)
├── include/       # Project-specific headers (if any)
├── lib/           # Project-specific libraries (if any)
├── model/         # MuJoCo XML model files
│   └── simple_box.xml
├── src/           # Source code
│   └── hello_world.cpp
├── build/         # CMake build directory (generated)
└── CMakeLists.txt # Build configuration
```

## Hello World Program

### Model File (`model/simple_box.xml`)

A simple scene with:
- A ground plane
- A free-falling red box

```xml
<mujoco>
  <worldbody>
    <light diffuse=".5 .5 .5" pos="0 0 3" dir="0 0 -1"/>
    <geom type="plane" size="1 1 0.1" rgba=".9 .9 .9 1"/>
    <body pos="0 0 0.2">
      <joint type="free"/>
      <geom type="box" size=".1 .1 .1" rgba="1 0 0 1"/>
    </body>
  </worldbody>
</mujoco>
```

### Source Code (`src/hello_world.cpp`)

The program demonstrates:
1. Loading a MuJoCo model from XML
2. Creating simulation data structures
3. Running a physics simulation
4. Accessing simulation state

Key MuJoCo API functions used:
- `mj_loadXML()` - Load model from XML file
- `mj_makeData()` - Create data structure for simulation
- `mj_step()` - Advance simulation by one timestep
- `mj_deleteData()`, `mj_deleteModel()` - Clean up resources

### Build Configuration (`CMakeLists.txt`)

```cmake
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
```

**Important**: The `RPATH` settings ensure the executable can find `libmujoco.so` at runtime without modifying `LD_LIBRARY_PATH`.

## Building and Running the Hello World Program

### Quick Start (Automated)

Use the provided build script:

```bash
cd /root/sdr-mujoco/mujoco-hello-world
./build_hello_world.sh
```

This will build the hello world example and show you how to run it.

**Options:**
```bash
./build_hello_world.sh [--clean]   # Clean rebuild
```

### Manual Build (Alternative)

```bash
cd /root/sdr-mujoco/mujoco-hello-world
mkdir -p build
cd build
cmake ..
cmake --build .
```

### Run the Program

```bash
# From the mujoco-hello-world directory
./build/hello_world model/simple_box.xml

# Or from the build directory
cd build
./hello_world ../model/simple_box.xml
```

### Expected Output

```
MuJoCo Hello World!
Model loaded successfully: ../model/simple_box.xml
Number of bodies: 2
Number of joints: 1
Number of geoms: 2
Number of DOFs: 6

Running simulation for 10 seconds...
Simulation complete!
Total steps: 5000
Final time: 10.000 seconds
Timestep: 0.00200 seconds

Final position of box:
  x: 0.000
  y: 0.000
  z: 0.100
```

The box falls from height 0.2m and settles on the ground plane at z=0.100m (the half-height of the 0.2m box).

## Dependencies Summary

### External Dependencies (Automatically Fetched by CMake)

MuJoCo's build system automatically downloads these dependencies:

- **qhull** (8.1-alpha3) - Convex hull computation
- **tinyxml2** - XML parsing
- **tinyobjloader** - OBJ mesh loading
- **ccd** - Collision detection library
- **abseil-cpp** - Google's C++ common libraries
- **googletest** - Testing framework
- **google-benchmark** - Benchmarking framework
- **glfw3** (3.3.10) - Window and input management
- **lodepng** - PNG image loading

### Python Dependencies (Optional)

If building Python bindings (not covered in this setup):
- See `python/requirements.txt` in the MuJoCo repository

## Verification

### Test MuJoCo Installation

Run the built-in simulate viewer (requires X11/graphics):
```bash
/root/sdr-mujoco/install/bin/simulate /root/sdr-mujoco/install/share/mujoco/model/humanoid/humanoid.xml
```

### Test Sample Programs

```bash
# Basic sample
/root/sdr-mujoco/install/bin/basic /root/sdr-mujoco/install/share/mujoco/model/humanoid/humanoid.xml

# Compile test
/root/sdr-mujoco/install/bin/compile /root/sdr-mujoco/install/share/mujoco/model/humanoid/humanoid.xml
```

## Troubleshooting

### Common Issues

1. **Missing `libxkbcommon-dev`**: 
   - Error: `Package 'xkbcommon>=0.5.0', required by 'virtual:world', not found`
   - Solution: `sudo apt-get install -y libxkbcommon-dev`

2. **Cannot find `libmujoco.so` at runtime**:
   - Ensure RPATH is set in CMakeLists.txt (see above)
   - Or set: `export LD_LIBRARY_PATH=/root/sdr-mujoco/install/lib:$LD_LIBRARY_PATH`

3. **CMake version too old**:
   - MuJoCo requires CMake 3.16 or newer
   - Ubuntu 24.04 ships with 3.28.3

## Next Steps

### Learning Resources

1. **Documentation**: https://mujoco.readthedocs.io/en/stable/programming/
2. **API Reference**: https://mujoco.readthedocs.io/en/stable/APIreference/
3. **Sample Code**: `/root/sdr-mujoco/mujoco/sample/`
4. **Model Gallery**: https://mujoco.readthedocs.io/en/stable/models.html

### Suggested Exercises

1. Modify `simple_box.xml` to add more objects
2. Create a pendulum or double pendulum model
3. Add control inputs (actuators)
4. Implement visualization using the `simulate` library
5. Explore the sample programs in `/root/sdr-mujoco/mujoco/sample/`

### Advanced Topics

- **OpenGL Rendering**: See `sample/basic.cc` for visualization example
- **Model Editing**: Use `mjSpec` API for procedural model creation
- **Python Bindings**: Install with `pip install mujoco` (uses pre-built binaries)
- **Custom Plugins**: See `/root/sdr-mujoco/mujoco/plugin/` for examples
- **Threading**: Use `mjData::thread_pool` for parallel computation

## References

- [MuJoCo GitHub](https://github.com/google-deepmind/mujoco)
- [MuJoCo Documentation](https://mujoco.readthedocs.io/)
- [Building from Source](https://mujoco.readthedocs.io/en/stable/programming/index.html#building-from-source)
- [Programming Guide](https://mujoco.readthedocs.io/en/stable/programming/index.html)
