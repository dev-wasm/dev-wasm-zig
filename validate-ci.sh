#!/bin/bash
set -e

echo "======================================"
echo "CI/CD Validation Script"
echo "======================================"
echo ""

# Check Zig version
echo "Step 1: Verify Zig installation"
zig version
echo ""

# Run unit tests
echo "Step 2: Run unit tests"
echo "  - Testing test_main.zig..."
zig test src/test_main.zig
echo ""
echo "  - Testing http.zig..."
zig test src/http.zig
echo ""

# Build WASM binaries
echo "Step 3: Build WASM binaries"
echo "  - Building main.wasm..."
zig build-exe src/main.zig -target wasm32-wasi -femit-bin=main.wasm
echo ""
echo "  - Building wagi.wasm..."
zig build-exe src/wagi.zig -target wasm32-wasi -femit-bin=wagi.wasm
echo ""
echo "  - Building http.wasm..."
zig build-exe src/http.zig -target wasm32-wasi -femit-bin=http.wasm
echo ""

# Verify WASM files
echo "Step 4: Verify WASM files created"
ls -lh *.wasm
echo ""
file *.wasm
echo ""

echo "======================================"
echo "All steps completed successfully!"
echo "======================================"
