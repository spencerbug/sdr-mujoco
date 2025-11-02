# MuJoCo Hello World

A minimal example demonstrating basic MuJoCo physics simulation in C++.

## Overview

This project provides a simple introduction to using MuJoCo's C API for physics simulation. It loads a basic scene (a box falling onto a plane), runs a 10-second simulation, and reports the results.

## Prerequisites

- MuJoCo compiled and installed (see `/root/sdr-mujoco/SETUP.md`)
- CMake 3.16+
- C++17 compiler

## Project Structure

```
mujoco-hello-world/
├── src/
│   └── hello_world.cpp    # Main program
├── model/
│   └── simple_box.xml     # Simple physics scene
├── build/                 # Build directory (generated)
├── bin/                   # Output directory (optional)
├── include/               # Project headers (optional)
├── lib/                   # Project libraries (optional)
└── CMakeLists.txt         # Build configuration
```

## Building

### Quick Start (Recommended)

Use the provided build script:

```bash
./build_hello_world.sh
```

This will check for MuJoCo installation, build the project, and show you how to run it.

**Options:**
```bash
./build_hello_world.sh          # Standard build
./build_hello_world.sh --clean  # Clean rebuild
```

### Manual Build (Alternative)

```bash
mkdir -p build
cd build
cmake ..
cmake --build .
```

## Running

```bash
# From the project root
./build/hello_world model/simple_box.xml

# Or from the build directory
cd build
./hello_world ../model/simple_box.xml

# Try with other models
./build/hello_world ../install/share/mujoco/model/humanoid/humanoid.xml
```

## Output

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

## What's Happening

1. **Model Loading**: The program loads `simple_box.xml` which defines:
   - A ground plane at z=0
   - A red box positioned at z=0.2 with a free joint (6 DOF)
   - A light source

2. **Simulation**: The physics engine simulates gravity acting on the box:
   - Default gravity: -9.81 m/s²
   - Default timestep: 0.002 seconds (500 Hz)
   - The box falls and collides with the ground

3. **Result**: After 10 seconds, the box has settled on the ground:
   - Final z-position: 0.100m (half the box height of 0.2m)
   - The box remains stationary after impact

## Key MuJoCo Concepts

### Model (`mjModel`)
Contains all constant parameters of the simulation:
- Geometry definitions
- Physical properties (mass, inertia)
- Joint configurations
- Simulation parameters

### Data (`mjData`)
Contains all time-varying state and computation results:
- Positions, velocities, accelerations
- Forces, contacts
- Sensor readings

### Main API Functions

- `mj_loadXML()` - Load model from XML file
- `mj_makeData()` - Allocate simulation data
- `mj_step()` - Advance simulation by one timestep
- `mj_deleteData()`, `mj_deleteModel()` - Free memory

## Customization Ideas

1. **Change the scene**:
   - Add more objects to `simple_box.xml`
   - Try different shapes: sphere, capsule, cylinder
   - Adjust object properties: size, mass, friction

2. **Modify simulation parameters**:
   - Change simulation duration
   - Print intermediate states
   - Track velocity or energy

3. **Add complexity**:
   - Create a pendulum or chain
   - Add actuators for control
   - Implement keyboard/mouse control
   - Add visualization (see `sample/basic.cc`)

## Learning Resources

- [MuJoCo Documentation](https://mujoco.readthedocs.io/)
- [Programming Guide](https://mujoco.readthedocs.io/en/stable/programming/)
- [API Reference](https://mujoco.readthedocs.io/en/stable/APIreference/)
- [XML Reference](https://mujoco.readthedocs.io/en/stable/XMLreference.html)
- Sample programs in `/root/sdr-mujoco/mujoco/sample/`

## Next Steps

1. Study the more complex samples:
   - `basic.cc` - Includes OpenGL visualization
   - `record.cc` - Shows how to record simulations
   - `compile.cc` - Demonstrates model compilation

2. Explore the model library:
   ```bash
   ls /root/sdr-mujoco/install/share/mujoco/model/
   ```

3. Try the interactive viewer:
   ```bash
   /root/sdr-mujoco/install/bin/simulate model/simple_box.xml
   ```

## License

This example follows MuJoCo's Apache 2.0 license.
