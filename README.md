# termux-rz-ghidra

Ghidra decompiler plugin for [rizin](https://rizin.re), built on Termux
(`android/arm64`) from [rizinorg/rz-ghidra](https://github.com/rizinorg/rz-ghidra)
v0.9.0 against the Termux `rizin` 0.9.1 package.

This gives `pdg` (Ghidra pseudo-C decompilation) inside rizin on a phone —
something upstream does not ship for this platform.

## Build

```bash
chmod +x build.sh
./build.sh
```

What it does: shallow-clones rz-ghidra + submodules (sleigh specs, pugixml),
configures with cmake (`-O1` for the RAM cap), compiles with `-j2`, installs
`core_ghidra.so` + `rz_ghidra_sleigh/*.sla` (including `AARCH64.sla`) to
`~/.local`. Expect a long build (100+ C++ targets, single-digit threads).

The compiled `.so` files are intentionally **not** committed — build locally.

## Use

```bash
export SLEIGHHOME="$HOME/.local/lib/rizin/plugins/rz_ghidra_sleigh"
rizin -q -c 'e scr.color=false; aaa; pdg @ sym.my_function' ./target.so
```

Note: the plugin resolves its sleigh specs through the `SLEIGHHOME`
environment variable (not an `RZ_*` name). Without it you get
`No sleigh specification for AARCH64:LE:64:v8A`.

## Limits

- rizin ships without the `pdg` (rz-ghidra) command in Termux repos — that is
  what this repo provides the build for.
- Big binaries analyze slowly under a 1–2 GB RAM cap; work one target at a time.

Independent community project. Not affiliated with the rizin or Ghidra authors.
Ghidra is developed by the NSA and released under Apache 2.0; see LICENSES
upstream for component terms.
