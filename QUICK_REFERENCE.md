# MuJoCo Quick Reference

Quick commands and tips for working with MuJoCo.

## First Time Setup

### Build MuJoCo (Automated)
```bash
cd /root/sdr-mujoco
./build_mujoco.sh
```

**Options:**
- `--clean` - Clean rebuild
- `--skip-deps` - Skip apt-get install
- `--debug` - Debug build
- `--verbose` - Verbose output
- `--help` - Show all options

### Build Hello World
```bash
cd mujoco-hello-world
./build_hello_world.sh
```

## Quick Start Commands

### Run Hello World
```bash
cd /root/sdr-mujoco/mujoco-hello-world
./build/hello_world model/simple_box.xml
```

### Run Interactive Simulator
```bash
# Humanoid model
/root/sdr-mujoco/install/bin/simulate \
  /root/sdr-mujoco/install/share/mujoco/model/humanoid/humanoid.xml

# Your custom model
/root/sdr-mujoco/install/bin/simulate \
  /root/sdr-mujoco/mujoco-hello-world/model/simple_box.xml
```

### Run Sample Programs
```bash
# Basic visualization
/root/sdr-mujoco/install/bin/basic \
  /root/sdr-mujoco/install/share/mujoco/model/humanoid/humanoid.xml

# Test model compilation speed
/root/sdr-mujoco/install/bin/testspeed \
  /root/sdr-mujoco/install/share/mujoco/model/humanoid/humanoid.xml
```

## Directory Locations

| Component | Path |
|-----------|------|
| MuJoCo source | `/root/sdr-mujoco/mujoco` |
| Build directory | `/root/sdr-mujoco/build` |
| Installation | `/root/sdr-mujoco/install` |
| Hello World | `/root/sdr-mujoco/mujoco-hello-world` |
| Sample models | `/root/sdr-mujoco/install/share/mujoco/model` |
| Headers | `/root/sdr-mujoco/install/include/mujoco` |
| Library | `/root/sdr-mujoco/install/lib/libmujoco.so` |

## Environment Variables

### Set Library Path (if needed)
```bash
export LD_LIBRARY_PATH=/root/sdr-mujoco/install/lib:$LD_LIBRARY_PATH
```

### Set MuJoCo directory for CMake
```bash
export MUJOCO_DIR=/root/sdr-mujoco/install
```

## Building New Projects

### 1. Create Project Structure
```bash
mkdir -p my_project/{src,model,build}
cd my_project
```

### 2. Create CMakeLists.txt
```cmake
cmake_minimum_required(VERSION 3.16)
project(my_project)

set(CMAKE_CXX_STANDARD 17)
set(MUJOCO_DIR "/root/sdr-mujoco/install")

include_directories(${MUJOCO_DIR}/include)
link_directories(${MUJOCO_DIR}/lib)

add_executable(my_program src/main.cpp)
target_link_libraries(my_program mujoco)

set_target_properties(my_program PROPERTIES
    BUILD_RPATH "${MUJOCO_DIR}/lib"
    INSTALL_RPATH "${MUJOCO_DIR}/lib"
)
```

### 3. Build
```bash
cd build
cmake ..
cmake --build .
```

## Common MuJoCo API Patterns

### Basic Simulation Loop
```cpp
#include <mujoco/mujoco.h>

// Load model
mjModel* m = mj_loadXML("model.xml", NULL, error, 1000);
mjData* d = mj_makeData(m);

// Simulation loop
while (d->time < duration) {
    mj_step(m, d);
}

// Cleanup
mj_deleteData(d);
mj_deleteModel(m);
```

### Access State Variables
```cpp
// Position of body i (3D vector)
d->xpos[3*i + 0]  // x
d->xpos[3*i + 1]  // y
d->xpos[3*i + 2]  // z

// Velocity
d->qvel[i]        // Generalized velocity

// Forces
d->qfrc_applied[i] // Applied forces
```

### Control Inputs
```cpp
// Set actuator controls
d->ctrl[actuator_id] = value;

// Apply external force
d->xfrc_applied[6*body_id + 0] = fx;
d->xfrc_applied[6*body_id + 1] = fy;
d->xfrc_applied[6*body_id + 2] = fz;
```

## Useful Model Files

Explore these example models:

```bash
cd /root/sdr-mujoco/install/share/mujoco/model

# Simple models
ls humanoid/humanoid.xml
ls car/car.xml
ls cube/cube_3x3x3.xml

# Advanced models
ls flex/              # Soft body simulation
ls plugin/            # Plugin examples
ls replicate/         # Procedural generation
```

## Rebuild MuJoCo

If you need to rebuild MuJoCo from source:

### Using the build script (recommended)
```bash
cd /root/sdr-mujoco
./build_mujoco.sh --clean
```

### Manual rebuild
```bash
cd /root/sdr-mujoco/build
cmake --build . --clean-first -j$(nproc)
cmake --install .
```

## Documentation Links

- **Main Docs**: https://mujoco.readthedocs.io/
- **Programming**: https://mujoco.readthedocs.io/en/stable/programming/
- **API Reference**: https://mujoco.readthedocs.io/en/stable/APIreference/
- **XML Reference**: https://mujoco.readthedocs.io/en/stable/XMLreference.html
- **Python Bindings**: https://mujoco.readthedocs.io/en/stable/python.html

## Troubleshooting

### Program can't find libmujoco.so
```bash
# Option 1: Set LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/root/sdr-mujoco/install/lib:$LD_LIBRARY_PATH

# Option 2: Use RPATH in CMakeLists.txt (recommended)
set_target_properties(my_target PROPERTIES
    BUILD_RPATH "${MUJOCO_DIR}/lib"
)
```

### Check MuJoCo Version
```bash
/root/sdr-mujoco/install/bin/simulate --version
# or check the library
strings /root/sdr-mujoco/install/lib/libmujoco.so | grep "version"
```

### Verify Installation
```bash
# Check if library exists
ls -lh /root/sdr-mujoco/install/lib/libmujoco.so*

# Check headers
ls /root/sdr-mujoco/install/include/mujoco/

# Run a sample
/root/sdr-mujoco/install/bin/basic \
  /root/sdr-mujoco/install/share/mujoco/model/humanoid/humanoid.xml
```

## Tips

1. **Start with samples**: Copy and modify examples from `/root/sdr-mujoco/mujoco/sample/`
2. **Use simulate for debugging**: Visualize your models interactively before coding
3. **Check MUJOCO_LOG.TXT**: Error messages are written to this file in the executable directory
4. **Read the docs**: The MuJoCo documentation is excellent and comprehensive
5. **Explore models**: The included model gallery has great examples to learn from
