# nixos

## Installation

### Partition disks
```shell
sudo mkfs.fat -F 32 /dev/sda1
sudo fatlabel /dev/sda1 NIXBOOT
sudo mkfs.ext4 /dev/sda2 -L NIXROOT
```

### Mount disks

```shell
sudo mount /dev/disk/by-label/NIXROOT /mnt
sudo mount --mkdir /dev/disk/by-label/NIXBOOT /mnt/boot
```

### Initial Installation

```shell
sudo nixos-install --no-root-passwd --flake github:littlestfluffy/nixos#HOSTNAME
```

## Updating

```shell
sudo nixos-rebuild switch --flake github:littlestfluffy/nixos#HOSTNAME
```
