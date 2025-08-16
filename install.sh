#!/usr/bin/env bash
set -euo pipefail

# -------------------------
# Usage check
# -------------------------
if [ $# -lt 1 ]; then
  echo "Usage: $0 <hostname> [disk]"
  exit 1
fi

HOSTNAME="$1"
DISK="${2:-}"

# -------------------------
# Check for root
# -------------------------
if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root. Try: sudo $0 $*"
  exit 1
fi

# -------------------------
# Optional disk formatting
# -------------------------
if [ -n "$DISK" ]; then
  echo "Wiping and partitioning $DISK..."
  wipefs -a "$DISK"
  parted "$DISK" --script mklabel msdos
  parted "$DISK" --script mkpart primary ext4 1MiB 1024MiB
  parted "$DISK" --script mkpart primary ext4 1025MiB 100%

  mkfs.ext4 "${DISK}1" -L NIXBOOT
  mkfs.ext4 "${DISK}2" -L NIXROOT

  mount "${DISK}2" /mnt
  mount --mkdir "${DISK}1" /mnt/boot
fi

# -------------------------
# Install NixOS via flake
# -------------------------
echo "Installing NixOS for hostname '$HOSTNAME'..."
nixos-install --impure --no-root-passwd --flake "github:littlestfluffy/nixos#$HOSTNAME --accept-flake-config"

echo "✅ NixOS installation complete! Reboot into your new system."
