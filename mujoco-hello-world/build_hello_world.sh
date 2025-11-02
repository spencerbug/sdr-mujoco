#!/bin/bash
# Build script for MuJoCo Hello World example
# Usage: ./build_hello_world.sh [--clean]

set -e  # Exit on error

# Color output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${SCRIPT_DIR}/build"
MUJOCO_DIR="${SCRIPT_DIR}/../install"

# Parse arguments
CLEAN_BUILD=false
if [ "$1" = "--clean" ] || [ "$1" = "-c" ]; then
    CLEAN_BUILD=true
fi

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}       Building MuJoCo Hello World${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Check if MuJoCo is installed
if [ ! -d "${MUJOCO_DIR}" ]; then
    echo -e "${RED}Error: MuJoCo installation not found at ${MUJOCO_DIR}${NC}"
    echo ""
    echo "Please build MuJoCo first:"
    echo -e "  ${GREEN}cd ..${NC}"
    echo -e "  ${GREEN}./build_mujoco.sh${NC}"
    exit 1
fi

if [ ! -f "${MUJOCO_DIR}/lib/libmujoco.so" ]; then
    echo -e "${RED}Error: MuJoCo library not found${NC}"
    echo "Please ensure MuJoCo is built and installed."
    exit 1
fi

# Clean if requested
if [ "$CLEAN_BUILD" = true ]; then
    echo -e "${YELLOW}Cleaning build directory...${NC}"
    rm -rf "${BUILD_DIR}"
    echo -e "${GREEN}✓ Clean complete${NC}"
    echo ""
fi

# Create build directory
mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"

# Configure
echo -e "${YELLOW}Configuring with CMake...${NC}"
cmake .. -DCMAKE_BUILD_TYPE=Release

echo -e "${GREEN}✓ Configuration complete${NC}"
echo ""

# Build
echo -e "${YELLOW}Building...${NC}"
cmake --build .

echo -e "${GREEN}✓ Build complete${NC}"
echo ""

# Success message
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}Hello World built successfully!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "Run it with:"
echo -e "  ${GREEN}./build/hello_world model/simple_box.xml${NC}"
echo ""
echo "Or try other models:"
echo -e "  ${GREEN}./build/hello_world ../install/share/mujoco/model/humanoid/humanoid.xml${NC}"
echo ""
