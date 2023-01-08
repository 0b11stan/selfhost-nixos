# Nixos config for selfhost server

## Installation

```bash
sudo loadkeys fr
sudo -i 
ls /sys/firmware/efi/efivars
ping -c 1 tic.sh
fdisk /dev/vda
# /dev/sdx1	2048	+512MB	EFI System
# /dev/sdx2	+512MB	100%	Linux LVM
pvcreate /dev/vda2
vgcreate main /dev/vda2
lvcreate -L 5G main -n root
lvcreate -L 3G main -n var
lvcreate -L 1G main -n home
lvcreate -L 1G main -n swap
mkfs.ext4 -L root /dev/main/root
mkfs.ext4 -L var /dev/main/var
mkfs.ext4 -L home /dev/main/home
mkswap -L swap /dev/main/swap
mkfs.fat -F 32 -n boot /dev/vda1
mount /dev/disk/by-label/root /mnt/
mkdir /mnt/home
mount /dev/disk/by-label/home /mnt/home
mkdir /mnt/var
mount /dev/disk/by-label/var /mnt/var
mkdir /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
swapon /dev/disk/by-label/swap
nixos-generate-config --root /mnt/
vi /mnt/etc/nixos/configuration.nix
nixos-install
reboot
# after connect
passwd tristan
```
