#!/bin/bash
# MuJoCo Build Script
# Automates the installation of dependencies and compilation of MuJoCo from source
# Usage: ./build_mujoco.sh [options]

set -e  # Exit on error

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MUJOCO_SOURCE_DIR="${SCRIPT_DIR}/mujoco"
BUILD_DIR="${SCRIPT_DIR}/build"
INSTALL_DIR="${SCRIPT_DIR}/install"
BUILD_TYPE="Release"
NUM_JOBS=$(nproc)

# Parse command line arguments
SKIP_DEPS=false
CLEAN_BUILD=false
VERBOSE=false

print_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -s, --skip-deps       Skip system dependency installation"
    echo "  -c, --clean           Clean build directory before building"
    echo "  -d, --debug           Build in Debug mode instead of Release"
    echo "  -j, --jobs N          Number of parallel jobs (default: $(nproc))"
    echo "  -v, --verbose         Verbose output"
    echo "  -h, --help            Show this help message"
    echo ""
    echo "Example:"
    echo "  $0                    # Standard build"
    echo "  $0 --clean            # Clean build from scratch"
    echo "  $0 --skip-deps        # Skip apt-get install (if already done)"
}

while [[ $# -gt 0 ]]; do
    case $1 in
        -s|--skip-deps)
            SKIP_DEPS=true
            shift
            ;;
        -c|--clean)
            CLEAN_BUILD=true
            shift
            ;;
        -d|--debug)
            BUILD_TYPE="Debug"
            shift
            ;;
        -j|--jobs)
            NUM_JOBS="$2"
            shift 2
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -h|--help)
            print_usage
            exit 0
            ;;
        *)
            echo -e "${RED}Error: Unknown option $1${NC}"
            print_usage
            exit 1
            ;;
    esac
done

# Print header
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}       MuJoCo Build Script${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "Source directory:  ${GREEN}${MUJOCO_SOURCE_DIR}${NC}"
echo -e "Build directory:   ${GREEN}${BUILD_DIR}${NC}"
echo -e "Install directory: ${GREEN}${INSTALL_DIR}${NC}"
echo -e "Build type:        ${GREEN}${BUILD_TYPE}${NC}"
echo -e "Parallel jobs:     ${GREEN}${NUM_JOBS}${NC}"
echo ""

# Check if source directory exists
if [ ! -d "${MUJOCO_SOURCE_DIR}" ]; then
    echo -e "${RED}Error: MuJoCo source directory not found: ${MUJOCO_SOURCE_DIR}${NC}"
    echo "Please ensure the mujoco repository is cloned in the correct location."
    exit 1
fi

# Install system dependencies
if [ "$SKIP_DEPS" = false ]; then
    echo -e "${YELLOW}Step 1: Installing system dependencies...${NC}"
    
    # Check if running as root or with sudo
    if [ "$EUID" -ne 0 ]; then
        SUDO="sudo"
    else
        SUDO=""
    fi
    
    # Update package list
    echo "Updating package list..."
    $SUDO apt-get update -qq
    
    # Install dependencies
    echo "Installing build dependencies..."
    $SUDO apt-get install -y -qq \
        cmake \
        build-essential \
        libgl1-mesa-dev \
        libglu1-mesa-dev \
        libglfw3-dev \
        libxinerama-dev \
        libxcursor-dev \
        libxi-dev \
        libxkbcommon-dev \
        2>&1 | grep -v "is already the newest version" || true
    
    echo -e "${GREEN}✓ Dependencies installed${NC}"
    echo ""
else
    echo -e "${YELLOW}Skipping system dependency installation${NC}"
    echo ""
fi

# Clean build directory if requested
if [ "$CLEAN_BUILD" = true ]; then
    echo -e "${YELLOW}Step 2: Cleaning build directory...${NC}"
    if [ -d "${BUILD_DIR}" ]; then
        rm -rf "${BUILD_DIR}"
        echo -e "${GREEN}✓ Build directory cleaned${NC}"
    else
        echo "Build directory doesn't exist, nothing to clean"
    fi
    echo ""
else
    echo -e "${YELLOW}Step 2: Preparing build directory...${NC}"
    echo "Skipping clean (use --clean to force clean build)"
    echo ""
fi

# Create build directory
mkdir -p "${BUILD_DIR}"

# Configure with CMake
echo -e "${YELLOW}Step 3: Configuring with CMake...${NC}"
cd "${BUILD_DIR}"

if [ "$VERBOSE" = true ]; then
    cmake "${MUJOCO_SOURCE_DIR}" \
        -DCMAKE_BUILD_TYPE="${BUILD_TYPE}" \
        -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}"
else
    cmake "${MUJOCO_SOURCE_DIR}" \
        -DCMAKE_BUILD_TYPE="${BUILD_TYPE}" \
        -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}" \
        2>&1 | grep -E "^--|Error|Warning" || true
fi

echo -e "${GREEN}✓ CMake configuration complete${NC}"
echo ""

# Build
echo -e "${YELLOW}Step 4: Building MuJoCo (this may take several minutes)...${NC}"
START_TIME=$(date +%s)

if [ "$VERBOSE" = true ]; then
    cmake --build . -j${NUM_JOBS}
else
    # Show progress without overwhelming output
    cmake --build . -j${NUM_JOBS} 2>&1 | grep -E "^\[|Error|Warning|Built target" || true
fi

END_TIME=$(date +%s)
BUILD_DURATION=$((END_TIME - START_TIME))

echo -e "${GREEN}✓ Build complete (${BUILD_DURATION}s)${NC}"
echo ""

# Install
echo -e "${YELLOW}Step 5: Installing to ${INSTALL_DIR}...${NC}"

if [ "$VERBOSE" = true ]; then
    cmake --install .
else
    cmake --install . 2>&1 | grep -E "^--|Installing" | head -20
    echo "  ... (more files)"
fi

echo -e "${GREEN}✓ Installation complete${NC}"
echo ""

# Verify installation
echo -e "${YELLOW}Step 6: Verifying installation...${NC}"

if [ ! -f "${INSTALL_DIR}/lib/libmujoco.so" ]; then
    echo -e "${RED}Error: libmujoco.so not found in installation directory${NC}"
    exit 1
fi

if [ ! -f "${INSTALL_DIR}/bin/simulate" ]; then
    echo -e "${RED}Error: simulate executable not found in installation directory${NC}"
    exit 1
fi

MUJOCO_VERSION=$(strings "${INSTALL_DIR}/lib/libmujoco.so" | grep -E "^[0-9]+\.[0-9]+\.[0-9]+$" | head -1)

echo -e "${GREEN}✓ Installation verified${NC}"
echo ""

# Print summary
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}Build completed successfully!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "Installation details:"
echo "  • MuJoCo version: ${MUJOCO_VERSION}"
echo "  • Library:        ${INSTALL_DIR}/lib/libmujoco.so"
echo "  • Headers:        ${INSTALL_DIR}/include/mujoco/"
echo "  • Executables:    ${INSTALL_DIR}/bin/"
echo "  • Models:         ${INSTALL_DIR}/share/mujoco/model/"
echo ""
echo "Try it out:"
echo -e "  ${GREEN}${INSTALL_DIR}/bin/simulate \\${NC}"
echo -e "  ${GREEN}  ${INSTALL_DIR}/share/mujoco/model/humanoid/humanoid.xml${NC}"
echo ""
echo "Or run the hello world example:"
echo -e "  ${GREEN}cd mujoco-hello-world${NC}"
echo -e "  ${GREEN}./build_hello_world.sh${NC}"
echo ""
