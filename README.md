# MuJoCo Development Environment

Complete setup for MuJoCo physics simulation, compiled from source.

## 📁 Repository Structure

```
sdr-mujoco/
├── mujoco/               # MuJoCo source code (forked repo)
├── build/                # MuJoCo build directory
├── install/              # MuJoCo installation
│   ├── bin/             # Executables (simulate, samples)
│   ├── include/         # C/C++ headers
│   ├── lib/             # Libraries (libmujoco.so)
│   └── share/           # Model files
├── mujoco-hello-world/  # Example project
│   ├── src/            # Source code
│   ├── model/          # Model files
│   ├── build/          # Build directory
│   └── CMakeLists.txt  # Build configuration
├── SETUP.md            # Complete setup documentation
├── QUICK_REFERENCE.md  # Quick commands and tips
└── README.md           # This file
```

## 🚀 Quick Start

### First Time Setup

1. **Build MuJoCo** (automated script):
```bash
./build_mujoco.sh
```

This will:
- Install all system dependencies
- Compile MuJoCo from source
- Install to `install/` directory

2. **Build and Run Hello World**:
```bash
cd mujoco-hello-world
./build_hello_world.sh
./build/hello_world model/simple_box.xml
```

### After Setup

```bash
# Activate conda environment (optional)
conda activate mujoco-dev

# Run interactive simulator
./install/bin/simulate install/share/mujoco/model/humanoid/humanoid.xml
```

### Build Script Options

```bash
# Standard build
./build_mujoco.sh

# Clean rebuild (if needed)
./build_mujoco.sh --clean

# Skip dependency installation (if already installed)
./build_mujoco.sh --skip-deps

# Debug build with verbose output
./build_mujoco.sh --debug --verbose

# Show all options
./build_mujoco.sh --help
```

## 📚 Documentation

| File | Description |
|------|-------------|
| **[GETTING_STARTED.md](GETTING_STARTED.md)** | **👈 Start here! Complete beginner's guide** |
| [SETUP.md](SETUP.md) | Detailed installation and build instructions |
| [QUICK_REFERENCE.md](QUICK_REFERENCE.md) | Quick commands and API patterns |
| [EXAMPLES.md](EXAMPLES.md) | Example commands to explore MuJoCo |
| [mujoco-hello-world/README.md](mujoco-hello-world/README.md) | Hello World example documentation |

## 🔧 What Was Done

### 1. System Dependencies Installed
- CMake, GCC/G++ compiler toolchain
- OpenGL development libraries
- GLFW for window management
- X11 extensions and keyboard libraries

**All automated via `build_mujoco.sh` script**

### 2. MuJoCo Compiled from Source
- Built MuJoCo 3.3.8 in Release mode
- Installed to `install/` directory
- All dependencies automatically fetched

**Run:** `./build_mujoco.sh`

### 3. Hello World Example Created
- Simple C++ program demonstrating MuJoCo basics
- Model with a falling box
- Proper CMake configuration with RPATH

**Build:** `cd mujoco-hello-world && ./build_hello_world.sh`

### 4. Documentation Written
- Comprehensive setup guide
- Quick reference for common tasks
- Example project documentation
- Build automation scripts

## 🎯 Next Steps

### Learn MuJoCo
1. Read the [Programming Guide](https://mujoco.readthedocs.io/en/stable/programming/)
2. Explore sample programs in `mujoco/sample/`
3. Try different models in `install/share/mujoco/model/`

### Build Your Own Projects
1. Copy the `mujoco-hello-world` structure
2. Modify the model XML file
3. Update the C++ code
4. Build with CMake

### Advanced Topics
- Add OpenGL visualization (see `sample/basic.cc`)
- Implement control systems
- Use Python bindings
- Create custom plugins

## 🔗 Resources

- **Official Documentation**: https://mujoco.readthedocs.io/
- **GitHub Repository**: https://github.com/google-deepmind/mujoco
- **API Reference**: https://mujoco.readthedocs.io/en/stable/APIreference/
- **Model Gallery**: https://mujoco.readthedocs.io/en/stable/models.html

## ✅ Verification

Everything is working if:
- ✅ Hello world runs successfully
- ✅ Sample programs execute without errors
- ✅ Models load correctly
- ✅ No library path issues

## 🐛 Troubleshooting

See `QUICK_REFERENCE.md` for common issues and solutions.

If you encounter problems:
1. Check `MUJOCO_LOG.TXT` in the executable directory
2. Verify library path: `echo $LD_LIBRARY_PATH`
3. Ensure RPATH is set in CMakeLists.txt

## 📦 Package Versions

- **MuJoCo**: 3.3.8
- **CMake**: 3.28.3
- **GCC**: 13.3.0
- **Python**: 3.11 (conda environment)
- **OS**: Ubuntu 24.04

## 🎓 Learning Path

1. **Beginner**: 
   - Run hello_world
   - Modify simple_box.xml
   - Explore sample models

2. **Intermediate**:
   - Study `sample/basic.cc` for visualization
   - Create custom models
   - Implement simple controllers

3. **Advanced**:
   - Multi-threaded simulation
   - Custom plugins
   - Integration with robotics frameworks

---

**Setup Date**: November 2, 2025  
**MuJoCo Version**: 3.3.8  
**Status**: ✅ Ready for development
