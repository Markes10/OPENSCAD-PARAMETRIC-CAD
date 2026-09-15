#!/usr/bin/env bash
# Render OpenSCAD parametric planetary gearbox to STL 3D mesh and PNG rendering
set -e

echo "=== OpenSCAD Generative Parametric CAD Compiler ==="

SCAD_SRC="src/planetary_gearbox.scad"

if command -v openscad &> /dev/null; then
    echo "[1/2] Compiling CSG tree to manufacturing STL mesh..."
    openscad -o build/planetary_gearbox.stl "$SCAD_SRC"

    echo "[2/2] Rendering raytraced PNG isometric preview..."
    openscad -o build/planetary_gearbox.png --imgsize=1920,1080 --camera=0,0,0,60,0,30,250 "$SCAD_SRC"
    echo "[SUCCESS] Generated STL mesh and PNG rendering."
else
    echo "[INFO] openscad CLI not installed. Running geometric CSG validator..."
    node runner/run.js
fi
