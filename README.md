# nixos

## Preparation

### Remote SSH Access

You can optionally directly enable SSH login to allow remote access during the installation process, for this simply configure a password

You can figure out the machine IP by using the following command
```shell
ip addr show
```

```shell
passwd
```

On your other machine you can then SSH into the machine with:
```shell
ssh nixos@IP
```

## Installation

### Automatic

```shell
curl -L https://raw.githubusercontent.com/littlestfluffy/nixos/main/install.sh | sudo bash -s <HOSTNAME> [/dev/DRIVE]
```

### Partition disks

#### EUFI
```shell
sudo mkfs.fat -F 32 /dev/sda1
sudo fatlabel /dev/sda1 NIXBOOT
sudo mkfs.ext4 /dev/sda2 -L NIXROOT
```

#### BIOS
```shell
sudo mkfs.ext4 /dev/sda1 -L NIXBOOT
sudo mkfs.ext4 /dev/sda2 -L NIXROOT
```

### Mount disks

```shell
sudo mount /dev/disk/by-label/NIXROOT /mnt
sudo mount --mkdir /dev/disk/by-label/NIXBOOT /mnt/boot
```

### Initial Installation

```shell
sudo nixos-generate-config --root /mnt
sudo nixos-install --no-root-passwd --flake github:littlestfluffy/nixos#HOSTNAME --accept-flake-config
```

## Updating

```shell
sudo nixos-rebuild switch --refresh --flake github:littlestfluffy/nixos
```
