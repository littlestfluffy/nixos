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
  echo "⚠️  About to wipe and partition $DISK. Make sure this is correct!"
  read -p "Type YES to continue: " CONFIRM
  if [ "$CONFIRM" != "YES" ]; then
    echo "Aborted by user."
    exit 1
  fi

  echo "Wiping and partitioning $DISK..."
  wipefs -a "$DISK"
  parted "$DISK" -- mklabel MBR
  parted "$DISK" -- mkpart primary ext4 1MiB 512MiB
  parted "$DISK" -- mkpart primary ext4 513MiB 100%
  mkfs.ext4 "${DISK}1" -L NIXBOOT
  mkfs.ext4 "${DISK}2" -L NIXROOT
  mount "${DISK}2" /mnt
  mount --mkdir "${DISK}1" /mnt/boot
fi

# -------------------------
# Install NixOS via flake
# -------------------------
echo "Installing NixOS for hostname '$HOSTNAME'..."
if [ -n "$DISK" ]; then
  nixos-install --impure --no-root-passwd --flake "github:littlestfluffy/nixos#$HOSTNAME"
else
  nixos-install --impure --no-root-passwd --flake "github:littlestfluffy/nixos#$HOSTNAME"
fi

echo "✅ NixOS installation complete! Reboot into your new system."
