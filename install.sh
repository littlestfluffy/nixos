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
# Disk formatting
# -------------------------
if [ -n "$DISK" ]; then
  echo "Wiping and partitioning $DISK..."
  wipefs -a "$DISK"

    if mountpoint -q /mnt/boot; then
      sudo umount /mnt/boot
    fi

    # Unmount /mnt if mounted
    if mountpoint -q /mnt; then
      sudo umount /mnt
    fi

  # Check for UEFI support
  if [ -d /sys/firmware/efi ]; then
    echo "UEFI detected. Creating EFI and root partitions..."
    parted "$DISK" --script mklabel gpt
    parted "$DISK" --script mkpart ESP fat32 1MiB 1024MiB
    parted "$DISK" --script set 1 boot on
    parted "$DISK" --script mkpart primary ext4 1025MiB 100%

    mkfs.fat -F32 "${DISK}1" -n EFI
    mkfs.ext4 "${DISK}2" -L NIXROOT

    mount "${DISK}2" /mnt
    mount --mkdir "${DISK}1" /mnt/boot
  else
    echo "No UEFI detected. Creating single root partition..."
    parted "$DISK" --script mklabel msdos
    parted "$DISK" --script mkpart primary ext4 1MiB 100%

    mkfs.ext4 "${DISK}1" -L NIXROOT

    mount "${DISK}1" /mnt
  fi
fi

# -------------------------
# Install NixOS via flake
# -------------------------
echo "Installing NixOS for hostname '$HOSTNAME'..."
nix-collect-garbage -d
nixos-install --impure --no-write-lock-file --no-root-passwd --flake "github:littlestfluffy/nixos#$HOSTNAME"

echo "✅ NixOS installation complete! Reboot into your new system."
