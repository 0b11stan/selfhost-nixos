# Nixos config for selfhost server

## Installation

```bash
sudo loadkeys fr
sudo -i 
ping -c 1 tic.sh
ls /sys/firmware/efi/efivars # => UEFI or MBR

## UEFI ##
parted /dev/sda -- mklabel gpt
fdisk /dev/vda
# /dev/sdx1	2048	+512MB	EFI System
# /dev/sdx2	+512MB	100%	Linux LVM
pvcreate /dev/vda2
vgcreate selfhost /dev/vda2
lvcreate -L 5G selfhost -n root
lvcreate -L 3G selfhost -n var
lvcreate -L 1G selfhost -n home
lvcreate -L 1G selfhost -n swap
mkfs.ext4 -L root /dev/selfhost/root
mkfs.ext4 -L var /dev/selfhost/var
mkfs.ext4 -L home /dev/selfhost/home
mkswap -L swap /dev/selfhost/swap
mkfs.fat -F 32 -n boot /dev/vda1
mount /dev/disk/by-label/root /mnt/
mkdir /mnt/home
mount /dev/disk/by-label/home /mnt/home
mkdir /mnt/var
mount /dev/disk/by-label/var /mnt/var
mkdir /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot

## MBR ##
parted /dev/sdb -- mklabel msdos
parted /dev/sdb -- mkpart primary 1MB 100%
pvcreate /dev/sdb1
vgcreate selfhost /dev/sdb1
lvcreate -L 5G selfhost -n root
lvcreate -L 3G selfhost -n var
lvcreate -L 1G selfhost -n home
lvcreate -L 1G selfhost -n swap
mkfs.ext4 -L root /dev/selfhost/root
mkfs.ext4 -L var /dev/selfhost/var
mkfs.ext4 -L home /dev/selfhost/home
mkswap -L swap /dev/selfhost/swap
mount /dev/disk/by-label/root /mnt/
mkdir /mnt/home
mount /dev/disk/by-label/home /mnt/home
mkdir /mnt/var
mount /dev/disk/by-label/var /mnt/var

swapon /dev/disk/by-label/swap
nixos-generate-config --root /mnt/
cp /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/hardware-configuration.remote.nix
passwd # change root password to something simple (azerty)

## FROM HOST ##
scp root@$RHOST:/mnt/etc/nixos/hardware-configuration.remote.nix /tmp/
# Update the configuration to match remote's specificity
cp src/hardware-configuration.nix src/hardware-configuration.remote.nix
nvim -O /tmp/hardware-configuration.remote.nix -O src/hardware-configuration.remote.nix
scp -r src/* root@$RHOST:/mnt/etc/nixos/

## FROM REMOTE ##
nixos-install
reboot
# after connect as root
passwd tristan
# 
ssh-keygen
cp ~/.ssh/id_rsa.pub /home/tristan/
ssh tristan@$IP cat /home/tristan/id_rsa.pub | wl-copy # from host
```

## ROADMAP

* [x] systemd service for deploying docker apps
* [x] backup and restore script for shynet
* [x] backup and restore script for pwndoc
* [x] backup and restore script for gitea
* [x] systemd service only reload needed apps
* [ ] backup script for nextcloud
* [ ] restore script for nextcloud
* [ ] merge hardware-configuration.virt.nix hardware-configuration.remote.nix 
* [ ] add prometheus for monitoring
* [ ] deploy bunkerweb as a WAF

## IP Blacklist 

Generated via the following command during an ssh bruteforce

```bash
docker logs docker-selfhost-gitea-1 | grep 'invalid user' | cut -d ' ' -f 6 | sort -u | tee /tmp/blacklist
```
