# nixos

## Installation

### Partition disks
```shell
sudo mkfs.fat -F 32 /dev/sda1
sudo fatlabel /dev/sda1 NIXBOOT
sudo mkfs.ext4 /dev/sda2 -L NIXROOT
```

### Mount & Install NixOS

```shell
sudo mount /dev/disk/by-label/NIXROOT /mnt
sudo mount --mkdir /dev/disk/by-label/NIXBOOT /mnt/boot

sudo nixos-install --no-write-lock-file --flake github:littlestfluffy/nixos#krolik
```
