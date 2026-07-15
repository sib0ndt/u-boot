#!/bin/bash
# RTD1619 U-Boot Build Script
# Builds mainline U-Boot with extlinux/distro boot support

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Configuration
CROSS_COMPILE="${CROSS_COMPILE:-aarch64-linux-gnu-}"
JOBS="${JOBS:-$(nproc)}"
DEFCONFIG="rtd1619_defconfig"

echo "========================================="
echo "RTD1619 U-Boot Build Script"
echo "========================================="
echo ""
echo "Cross compiler: ${CROSS_COMPILE}gcc"
echo "Parallel jobs: ${JOBS}"
echo "Defconfig: ${DEFCONFIG}"
echo ""

# Check cross compiler
if ! command -v "${CROSS_COMPILE}gcc" &> /dev/null; then
    echo "ERROR: Cross compiler not found: ${CROSS_COMPILE}gcc"
    echo "Install with: sudo apt install gcc-aarch64-linux-gnu"
    exit 1
fi

# Clean previous build
echo ">>> Cleaning previous build..."
make O=output mrproper

# Load defconfig
echo ""
echo ">>> Loading defconfig: ${DEFCONFIG}..."
make O=output ${DEFCONFIG}

# Show important config options
echo ""
echo ">>> Verifying extlinux support..."
grep -E "CONFIG_CMD_PXE|CONFIG_CMD_SYSBOOT|CONFIG_DISTRO_DEFAULTS|CONFIG_BOOTMETH_EXTLINUX" output/.config || echo "WARNING: Extlinux support may not be enabled"

# Build
echo ""
echo ">>> Building U-Boot..."
make O=output CROSS_COMPILE="${CROSS_COMPILE}" -j${JOBS} TEXT_BASE=5000000

# Check output
echo ""
echo "========================================="
echo "Build Complete!"
echo "========================================="
echo ""

if [ -f output/u-boot.bin ]; then
    U_BOOT_SIZE=$(stat -c%s output/u-boot.bin)
    echo "✅ u-boot.bin: $U_BOOT_SIZE bytes"
    ls -lh output/u-boot.bin
else
    echo "❌ u-boot.bin not found!"
    exit 1
fi

echo ""
echo "Output files:"
ls -lh output/u-boot* 2>/dev/null | grep -v "\.o$" || true

echo ""
echo "========================================="
echo "Installation Instructions"
echo "========================================="
echo ""
echo "For chainload from vendor bootloader:"
echo "  1. Copy u-boot.bin to boot partition"
echo "  2. Vendor LK will load and execute it"
echo ""
echo "Extlinux boot flow:"
echo "  1. Create /boot/extlinux/extlinux.conf"
echo "  2. U-Boot will auto-detect and boot"
echo ""

exit 0
