#!/bin/bash
# Build BetterSpades for WebAssembly using Emscripten
# Usage: cd BetterSpades && ./build-wasm.sh
#
# Prerequisites:
#   - Emscripten SDK (emsdk) installed and activated
#   - Run: source emsdk/emsdk_env.sh
#
# Installation (if emsdk not installed):
#   git clone https://github.com/emscripten-core/emsdk.git
#   cd emsdk
#   ./emsdk install latest
#   ./emsdk activate latest
#   source emsdk_env.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR="$SCRIPT_DIR/build-wasm"

echo "=== BetterSpades WebAssembly Build ==="
echo "Source: $SCRIPT_DIR"
echo "Build:  $BUILD_DIR"
echo ""

# Check for emcc
if ! command -v emcc &> /dev/null; then
    echo "ERROR: emcc not found. Please install and activate Emscripten SDK first."
    echo ""
    echo "Quick install:"
    echo "  git clone https://github.com/emscripten-core/emsdk.git"
    echo "  cd emsdk"
    echo "  ./emsdk install latest"
    echo "  ./emsdk activate latest"
    echo "  source emsdk_env.sh"
    exit 1
fi

echo "Emscripten version: $(emcc --version | head -1)"
echo ""

mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Clean previous build
rm -f CMakeCache.txt

# Configure with Emscripten toolchain
echo "=== Configuring ==="
emcmake cmake "$SCRIPT_DIR" \
    -DENABLE_GLFW=ON \
    -DENABLE_SDL=OFF \
    -DENABLE_SOUND=ON \
    -DENABLE_RPC=OFF \
    -DENABLE_OPENGLES=OFF \
    -DENABLE_TOUCH=OFF \
    -DCMAKE_BUILD_TYPE=Release

# Build
echo ""
echo "=== Building ==="
emmake make -j$(nproc 2>/dev/null || echo 4)

echo ""
echo "=== Build complete ==="
echo "Output: $BUILD_DIR/BetterSpades/"
echo "Files:"
ls -la "$BUILD_DIR/BetterSpades/"*.{html,js,wasm,data} 2>/dev/null || true
echo ""
echo "To serve locally:"
echo "  cd $BUILD_DIR/BetterSpades && python3 -m http.server 8080"
echo "  Open http://localhost:8080/client.html"
