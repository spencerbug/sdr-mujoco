# Getting Started with MuJoCo

This guide will help you get started with MuJoCo physics simulation, from installation to running your first simulation.

## 🎯 Prerequisites

- Linux system (Ubuntu 20.04+ recommended)
- Git (for cloning the repository)
- Internet connection (for downloading dependencies)
- Root/sudo access (for installing system packages)

## 📦 Installation

### Step 1: Clone the Repository

```bash
git clone https://github.com/spencerbug/sdr-mujoco.git
cd sdr-mujoco
```

### Step 2: Build MuJoCo

Run the automated build script:

```bash
./build_mujoco.sh
```

This will:
- ✅ Install all system dependencies (CMake, compilers, OpenGL, GLFW, etc.)
- ✅ Configure the build with CMake
- ✅ Compile MuJoCo from source (takes 5-10 minutes)
- ✅ Install to the `install/` directory

**Expected output:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
       MuJoCo Build Script
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Source directory:  /root/sdr-mujoco/mujoco
Build directory:   /root/sdr-mujoco/build
Install directory: /root/sdr-mujoco/install
...
✓ Build complete
✓ Installation complete
```

### Step 3: Verify Installation

Run the interactive simulator:

```bash
./install/bin/simulate install/share/mujoco/model/humanoid/humanoid.xml
```

You should see a 3D visualization of a humanoid robot!

## 🚀 Your First Simulation

### Option 1: Run Hello World Example

```bash
cd mujoco-hello-world
./build_hello_world.sh
./build/hello_world model/simple_box.xml
```

**Output:**
```
MuJoCo Hello World!
Model loaded successfully: model/simple_box.xml
Number of bodies: 2
Number of joints: 1
Number of geoms: 2
Number of DOFs: 6

Running simulation for 10 seconds...
Simulation complete!
Final position of box:
  x: 0.000
  y: 0.000
  z: 0.100
```

### Option 2: Interactive Simulation

Explore different models interactively:

```bash
# Humanoid robot
./install/bin/simulate install/share/mujoco/model/humanoid/humanoid.xml

# Car
./install/bin/simulate install/share/mujoco/model/car/car.xml

# Rubik's cube
./install/bin/simulate install/share/mujoco/model/cube/cube_3x3x3.xml

# Soft body (hammock)
./install/bin/simulate install/share/mujoco/model/hammock/hammock.xml
```

**Interactive Controls:**
- **Mouse drag**: Rotate view
- **Right-click drag**: Pan view
- **Scroll**: Zoom
- **Space**: Pause/resume
- **Backspace**: Reset simulation
- **F1**: Show help
- **Double-click**: Select and track body

## 📚 Learning Path

### Beginner (Day 1-2)

1. **Explore Models**: Run different models with the `simulate` viewer
   ```bash
   ls install/share/mujoco/model/
   ```

2. **Study Hello World**: Understand the basic API
   - Open `mujoco-hello-world/src/hello_world.cpp`
   - Read the comments
   - Try modifying the simulation time

3. **Modify a Model**: Edit `mujoco-hello-world/model/simple_box.xml`
   - Change box size: `<geom type="box" size=".2 .2 .2" .../>`
   - Add another box
   - Change colors

### Intermediate (Week 1)

1. **Study Sample Programs**: 
   ```bash
   ls mujoco/sample/
   ```
   - `basic.cc` - OpenGL visualization
   - `record.cc` - Recording simulations
   - `compile.cc` - Model compilation

2. **Create Custom Models**:
   - Build a pendulum
   - Create a chain of objects
   - Add actuators for control

3. **Learn the API**:
   - Read the [Programming Guide](https://mujoco.readthedocs.io/en/stable/programming/)
   - Explore the [API Reference](https://mujoco.readthedocs.io/en/stable/APIreference/)

### Advanced (Month 1+)

1. **Add Visualization**: 
   - Study `sample/basic.cc`
   - Implement OpenGL rendering in your programs

2. **Control Systems**:
   - Implement PID controllers
   - Use inverse kinematics
   - Track trajectories

3. **Custom Plugins**:
   - Explore `plugin/` directory
   - Create custom actuators or sensors

## 🔧 Common Tasks

### Create a New Project

```bash
# Copy the hello world template
cp -r mujoco-hello-world my_project
cd my_project

# Edit the code
vim src/hello_world.cpp

# Build and run
./build_hello_world.sh
./build/hello_world model/simple_box.xml
```

### Rebuild Everything

```bash
# Clean rebuild of MuJoCo
./build_mujoco.sh --clean

# Clean rebuild of hello world
cd mujoco-hello-world
./build_hello_world.sh --clean
```

### Browse Available Models

```bash
# List all models
find install/share/mujoco/model -name "*.xml"

# View a model's XML
cat install/share/mujoco/model/humanoid/humanoid.xml
```

## 📖 Documentation

| Document | Purpose |
|----------|---------|
| [README.md](README.md) | Project overview |
| [SETUP.md](SETUP.md) | Detailed setup documentation |
| [QUICK_REFERENCE.md](QUICK_REFERENCE.md) | Quick commands |
| [EXAMPLES.md](EXAMPLES.md) | Example commands to try |
| [mujoco-hello-world/README.md](mujoco-hello-world/README.md) | Hello World guide |

## 🆘 Troubleshooting

### Build Script Fails

**Problem**: `./build_mujoco.sh` fails with dependency errors

**Solution**: Run with verbose output to see details:
```bash
./build_mujoco.sh --clean --verbose
```

### Cannot Find Library

**Problem**: Program fails with "cannot find libmujoco.so"

**Solution**: The build scripts set RPATH automatically. If you still have issues:
```bash
export LD_LIBRARY_PATH=/root/sdr-mujoco/install/lib:$LD_LIBRARY_PATH
```

### Simulate Doesn't Display

**Problem**: `simulate` runs but shows no window

**Solution**: You need X11/graphics support. If running remotely:
```bash
# Enable X11 forwarding
ssh -X user@host

# Or use VNC/remote desktop
```

For headless systems, you can still use the non-visual programs:
```bash
./mujoco-hello-world/build/hello_world model/simple_box.xml
```

### Permission Denied on Scripts

**Problem**: `bash: ./build_mujoco.sh: Permission denied`

**Solution**: Make scripts executable:
```bash
chmod +x build_mujoco.sh
chmod +x mujoco-hello-world/build_hello_world.sh
```

## 🎓 Additional Resources

### Official Documentation
- [MuJoCo Documentation](https://mujoco.readthedocs.io/)
- [Programming Guide](https://mujoco.readthedocs.io/en/stable/programming/)
- [API Reference](https://mujoco.readthedocs.io/en/stable/APIreference/)
- [XML Reference](https://mujoco.readthedocs.io/en/stable/XMLreference.html)

### Community
- [GitHub Repository](https://github.com/google-deepmind/mujoco)
- [Forum/Discussions](https://github.com/google-deepmind/mujoco/discussions)

### Tutorials
- Python tutorials in `python/` directory
- Sample code in `mujoco/sample/`
- Model gallery: [online](https://mujoco.readthedocs.io/en/stable/models.html)

## 🎯 Next Steps

1. ✅ Successfully run `./build_mujoco.sh`
2. ✅ Run the hello world example
3. ✅ Explore models with `simulate`
4. 📝 Modify `simple_box.xml` to add your own objects
5. 📝 Write a program that applies forces to objects
6. 📝 Create a simple robot model
7. 📝 Implement a PID controller

Happy simulating! 🚀
