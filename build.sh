#!/data/data/com.termux/files/usr/bin/bash
# Build rz-ghidra (Ghidra decompiler plugin for rizin) on Termux android/arm64.
# RAM-capped: single config, -O1, -j2. Expects: pkg-installed rizin, cmake, git, clang.
set -euo pipefail

SRC="$HOME/rzbuild/rz-ghidra"
BUILD="$HOME/rzbuild/build"
PREFIX="$HOME/.local"

pkg install -y rizin cmake git 2>/dev/null || true

[ -d "$SRC" ] || git clone --depth 1 --branch v0.9.0 \
  https://github.com/rizinorg/rz-ghidra.git "$SRC"
git -C "$SRC" submodule update --init --depth 1

mkdir -p "$BUILD"
cmake -S "$SRC" -B "$BUILD" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="$PREFIX" \
  -DCMAKE_CXX_FLAGS="-O1" \
  -DCMAKE_C_FLAGS="-O1"
cmake --build "$BUILD" -j 2
cmake --install "$BUILD" --prefix "$PREFIX"

echo "Add to your shell profile:"
echo "  export SLEIGHHOME=\"\$HOME/.local/lib/rizin/plugins/rz_ghidra_sleigh\""
echo "Test:"
echo "  rizin -q -c 'e scr.color=false; aaa; pdg @ main' <binary>"
