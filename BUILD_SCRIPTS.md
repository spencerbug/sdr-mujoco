# Build Scripts Reference

Quick reference for all build automation scripts in this repository.

## 🔨 Main Build Scripts

### `build_mujoco.sh`
Builds MuJoCo from source with automatic dependency installation.

**Location**: `/root/sdr-mujoco/build_mujoco.sh`

**Usage**:
```bash
./build_mujoco.sh [OPTIONS]
```

**Options**:
- `-s, --skip-deps` - Skip system dependency installation
- `-c, --clean` - Clean build directory before building
- `-d, --debug` - Build in Debug mode instead of Release
- `-j, --jobs N` - Number of parallel jobs (default: nproc)
- `-v, --verbose` - Verbose output
- `-h, --help` - Show help message

**Examples**:
```bash
# First time setup
./build_mujoco.sh

# Rebuild from scratch
./build_mujoco.sh --clean

# If dependencies are already installed
./build_mujoco.sh --skip-deps

# Debug build with verbose output
./build_mujoco.sh --debug --verbose
```

**What it does**:
1. Installs system dependencies via apt-get
2. Configures build with CMake
3. Compiles MuJoCo using all CPU cores
4. Installs to `install/` directory
5. Verifies installation

**Output**:
- Binaries: `install/bin/`
- Libraries: `install/lib/libmujoco.so`
- Headers: `install/include/mujoco/`
- Models: `install/share/mujoco/model/`

---

### `mujoco-hello-world/build_hello_world.sh`
Builds the hello world example program.

**Location**: `/root/sdr-mujoco/mujoco-hello-world/build_hello_world.sh`

**Usage**:
```bash
cd mujoco-hello-world
./build_hello_world.sh [--clean]
```

**Options**:
- `--clean` or `-c` - Clean rebuild

**Examples**:
```bash
# Standard build
./build_hello_world.sh

# Clean rebuild
./build_hello_world.sh --clean
```

**What it does**:
1. Checks if MuJoCo is installed
2. Configures the project with CMake
3. Builds the executable
4. Shows you how to run it

**Requirements**:
- MuJoCo must be built first (run `../build_mujoco.sh`)

**Output**:
- Executable: `build/hello_world`

---

## 🚀 Quick Start Workflow

### First Time Setup

```bash
# 1. Build MuJoCo
./build_mujoco.sh

# 2. Build hello world example
cd mujoco-hello-world
./build_hello_world.sh

# 3. Run it
./build/hello_world model/simple_box.xml
```

### After Making Changes

```bash
# Rebuild MuJoCo (if you modified MuJoCo source)
./build_mujoco.sh --skip-deps

# Rebuild hello world (if you modified the example)
cd mujoco-hello-world
./build_hello_world.sh
```

### Clean Rebuild

```bash
# Clean rebuild of MuJoCo
./build_mujoco.sh --clean

# Clean rebuild of hello world
cd mujoco-hello-world
./build_hello_world.sh --clean
```

---

## 📝 Script Features

### Color-Coded Output
- 🔵 Blue: Headers and section titles
- 🟡 Yellow: Step descriptions
- 🟢 Green: Success messages
- 🔴 Red: Errors

### Error Handling
- Scripts exit on first error (`set -e`)
- Clear error messages
- Verification steps

### User-Friendly
- Progress indicators
- Estimated time for long operations
- Helpful next-step suggestions

---

## 🔧 Manual Build (Alternative)

If you prefer not to use scripts:

### MuJoCo Manual Build
```bash
# Install dependencies
sudo apt-get install -y cmake build-essential libgl1-mesa-dev \
    libglu1-mesa-dev libglfw3-dev libxinerama-dev libxcursor-dev \
    libxi-dev libxkbcommon-dev

# Configure
mkdir -p build && cd build
cmake ../mujoco -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/root/sdr-mujoco/install

# Build and install
cmake --build . -j$(nproc)
cmake --install .
```

### Hello World Manual Build
```bash
cd mujoco-hello-world
mkdir -p build && cd build
cmake ..
cmake --build .
```

---

## 🐛 Troubleshooting Scripts

### Script Won't Run
```bash
# Make executable
chmod +x build_mujoco.sh
chmod +x mujoco-hello-world/build_hello_world.sh
```

### Permission Denied (apt-get)
```bash
# Run with sudo if not root
sudo ./build_mujoco.sh
```

### See More Details
```bash
# Use verbose mode
./build_mujoco.sh --verbose
```

### Build Fails Midway
```bash
# Try clean rebuild
./build_mujoco.sh --clean --verbose
```

---

## 📦 Dependencies Installed by Scripts

The `build_mujoco.sh` script installs these packages:

- `cmake` - Build system
- `build-essential` - GCC/G++ compilers
- `libgl1-mesa-dev` - OpenGL headers
- `libglu1-mesa-dev` - OpenGL utilities
- `libglfw3-dev` - Window/input library
- `libxinerama-dev` - Multi-monitor support
- `libxcursor-dev` - Cursor management
- `libxi-dev` - Input extension
- `libxkbcommon-dev` - Keyboard handling

---

## ⚙️ Build Configuration

### Default Settings
- **Build Type**: Release (optimized)
- **Parallel Jobs**: All CPU cores (`nproc`)
- **Install Prefix**: `./install`

### Custom Configuration
```bash
# Debug build
./build_mujoco.sh --debug

# Limit CPU usage
./build_mujoco.sh --jobs 4

# Change install location (edit script)
INSTALL_DIR="/custom/path"
```

---

## 📊 Build Time Estimates

| Task | Time (approx) |
|------|---------------|
| Install dependencies | 30-60 seconds |
| CMake configuration | 10-20 seconds |
| MuJoCo compilation | 5-10 minutes |
| Installation | 10-20 seconds |
| Hello World build | 5-10 seconds |

Times vary based on system specs and internet speed.

---

## 💡 Tips

1. **First build**: Use standard `./build_mujoco.sh`
2. **Quick rebuilds**: Use `--skip-deps` after first build
3. **Something wrong**: Try `--clean` for fresh start
4. **See what's happening**: Add `--verbose`
5. **Save time**: Scripts run in parallel by default

---

For more information, see:
- [GETTING_STARTED.md](GETTING_STARTED.md) - Complete beginner's guide
- [SETUP.md](SETUP.md) - Detailed build documentation
- [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - Quick command reference
