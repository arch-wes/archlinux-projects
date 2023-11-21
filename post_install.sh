#!/usr/bin/env bash

#list with the links of flatpaks to install
FLATPAK_LIST=(
    flathub org.mozilla.firefox
    flathub com.visualstudio.code
    flathub org.gimp.GIMP
    flathub org.inkscape.Inkscape
    flathub org.videolan.VLC
    flathub com.google.Chrome
    flathub com.valvesoftware.Steam
    flathub org.libreoffice.LibreOffice
    flathub org.kde.krita
    flathub net.codeindustry.MasterPDFEditor
    flathub org.audacityteam.Audacity
    flathub net.ankiweb.Anki
    flathub com.github.tchx84.Flatseal
    flathub com.github.micahflee.torbrowser-launcher
    flathub com.github.unrud.VideoDownloader
    flathub net.agalwood.Motrix
)

#list of packages to install with pacman 
PACMAN_LIST=(
    gvfs
    nano 
    git 
    neofetch
    gufw
    ntfs-3g
    ffmpeg 
    gst-plugins-ugly 
    gst-plugins-good
    gst-plugins-base 
    gst-plugins-bad 
    gst-libav gstreamer
    --needed git
    linux-lts-headers
    virtualbox-host-dkms
    virtualbox-guest-iso
    flatpak
    qemu virt-manager
    virt-viewer
    dnsmasq
    vde2
    bridge-utils 
    openbsd-netcat 
    dmidecode
    virtualbox
)

#list of yay
YAY_LIST=(
    opencl-amd
    amdgpu-pro-oglp
    vulkan-amdgpu-pro
    preload
)

#function update system
update_system() {
sudo pacman -Syu -y
sudo pacman -Sc --noconfirm
}

#install package pacman
install_pacman() {
  for package in "${PACMAN_LIST[@]}"; do
   sudo pacman -S "$package"  -y --noconfirm
  done
}

#install package pacman
install_yay() {
  for yay in "${YAY_LIST[@]}"; do
   yay -S "$yay"  -y --noconfirm
  done
}

#install package pacman
install_flatpak() {
  for flatpak in "${FLATPAK_LIST[@]}"; do
   flatpak install "$flatpak" -y --or-update
  done
}

#install aur
install_aur() {
  git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si && yay -Y –gendb && cd

}

#update aur yay
update_yay() {
  yay -Sua
}

#update flatpak
update_flatpak() {
  flatpak update
}

#systemctl and systemd
systemctl_systemd() {
  sudo usermod -a -G libvirt $USER && systemctl enable libvirtd.service && systemctl start libvirtd.service --now
  systemd-modules-load.service
  sudo modprobe vboxdrv vboxnetadp vboxnetflt
  sudo modprobe -a vboxguest vboxsf vboxvideo
  sudo gpasswd -a $USER vboxusers
  sudo systemctl enable preload
  echo "all things is done!, is time to reboot"
  sleep 5
}

cd
update_system
install_pacman
install_aur
update_yay
install_yay
update_flatpak
install_flatpak
systemctl_systemd

#do a update and restart system
update_system
reboot
