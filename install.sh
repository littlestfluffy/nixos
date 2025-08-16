#!/usr/bin/env bash
set -euo pipefail

# ====== Usage ======
usage() {
    echo "Usage: $0 <hostname> [disk]"
    echo "Example: $0 myhost /dev/sda"
    exit 1
}

# ====== Parse arguments ======
HOSTNAME=${1:-""}
DISK=${2:-""}  # optional

if [[ -z "$HOSTNAME" ]]; then
    usage
fi

FLAKE="github:littlestfluffy/nixos" # your flake

# ====== Optional disk preparation ======
if [[ -n "$DISK" ]]; then
    if [ ! -b "$DISK" ]; then
        echo "Error: Disk $DISK does not exist."
        exit 1
    fi

    read -p "WARNING: This will wipe $DISK. Are you sure? [y/N] " confirm
    if [[ "$confirm" != "y" ]]; then
        echo "Aborted."
        exit 0
    fi

    echo "Partitioning $DISK..."
    wipefs -a "$DISK"
    parted "$DISK" -- mklabel MBR
    parted "$DISK" -- mkpart primary ext4 1MiB 512MiB
    parted "$DISK" -- mkpart primary ext4 513MiB 100%

    echo "Formatting partitions..."
    mkfs.ext4 "${DISK}1" -L NIXBOOT
    mkfs.ext4 "${DISK}2" -L NIXROOT

    echo "Mounting partitions..."
    mount "${DISK}2" /mnt
    mkdir -p /mnt/boot
    mount "${DISK}1" /mnt/boot
else
    echo "No disk provided. Skipping partitioning."
fi

# ====== Install NixOS from flake ======
echo "Running nixos-install for hostname '$HOSTNAME'..."
sudo nixos-install \
    --impure \
    --no-root-passwd \
    --flake "${FLAKE}#${HOSTNAME}" \
    ${DISK:+disk="$DISK"}  # pass disk if provided

echo "Installation complete. Rebooting..."
reboot
