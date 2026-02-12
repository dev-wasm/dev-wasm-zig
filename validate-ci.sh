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

# Execute WASM binaries and validate output
echo "Step 5: Execute WASM binaries and validate output"
echo ""

# Test main.wasm
echo "  - Testing main.wasm execution..."
# Create a temp directory for main.wasm to write files
TEMP_DIR=$(mktemp -d)
OUTPUT=$(wasmtime main.wasm --dir "$TEMP_DIR" 2>&1)
echo "$OUTPUT"

# Validate main.wasm output
if echo "$OUTPUT" | grep -q "Hello, Zig!"; then
    echo "    ✓ main.wasm: Output contains expected greeting"
else
    echo "    ✗ main.wasm: Expected greeting not found"
    exit 1
fi

# Validate that test.txt was created
if [ -f "$TEMP_DIR/test.txt" ]; then
    CONTENT=$(cat "$TEMP_DIR/test.txt")
    if [ "$CONTENT" = "This is a test" ]; then
        echo "    ✓ main.wasm: test.txt created with correct content"
    else
        echo "    ✗ main.wasm: test.txt has incorrect content"
        exit 1
    fi
else
    echo "    ✗ main.wasm: test.txt was not created"
    exit 1
fi

# Validate that test2.txt was created with same content
if [ -f "$TEMP_DIR/test2.txt" ]; then
    CONTENT2=$(cat "$TEMP_DIR/test2.txt")
    if [ "$CONTENT2" = "This is a test" ]; then
        echo "    ✓ main.wasm: test2.txt created with correct content"
    else
        echo "    ✗ main.wasm: test2.txt has incorrect content"
        exit 1
    fi
else
    echo "    ✗ main.wasm: test2.txt was not created"
    exit 1
fi

# Cleanup
rm -rf "$TEMP_DIR"
echo ""

# Test wagi.wasm
echo "  - Testing wagi.wasm execution..."
OUTPUT=$(wasmtime wagi.wasm 2>&1)
echo "$OUTPUT"

# Validate wagi.wasm output
if echo "$OUTPUT" | grep -q "Content-type: text/html"; then
    echo "    ✓ wagi.wasm: Output contains correct Content-type header"
else
    echo "    ✗ wagi.wasm: Content-type header not found"
    exit 1
fi

if echo "$OUTPUT" | grep -q "Hello world!"; then
    echo "    ✓ wagi.wasm: Output contains expected HTML content"
else
    echo "    ✗ wagi.wasm: Expected HTML content not found"
    exit 1
fi

# Test with QUERY_STRING environment variable
OUTPUT_WITH_QS=$(QUERY_STRING="test=123" wasmtime wagi.wasm 2>&1)
if echo "$OUTPUT_WITH_QS" | grep -q "test=123"; then
    echo "    ✓ wagi.wasm: QUERY_STRING environment variable is processed correctly"
else
    echo "    ✗ wagi.wasm: QUERY_STRING not found in output"
    exit 1
fi
echo ""

# Note: http.wasm requires network access and experimental WASI HTTP support
# which is not available in standard wasmtime, so we skip execution test for it
echo "  - Skipping http.wasm execution (requires wasmtime-http with network access)"
echo "    ℹ http.wasm build validation passed in Step 3"
echo ""

echo "======================================"
echo "All steps completed successfully!"
echo "======================================"
