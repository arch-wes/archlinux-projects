#!/bin/bash

pacman_list=(
    --needed xorg 
    xf86-video-amdgpu
    xfce4 
    xfce4-goodies 
    alacritty 
    xdg-user-dirs-gtk 
    pulseaudio 
    pavucontrol 
    qtile 
    firefox 
    lxappearance
    nitrogen
    picom
    lightdm
    lightdm-gtk-greeter
    lightdm-gtk-greeter-settings
)

#prepara os discos e as informaçoes necessarias para a instalação
preparar_discos(){
    cfdisk
    echo "qual é o disco que será instalado o arch?"
    echo "sem a numeração por exemplo sda1 digite só sda"
    read -r DISCO
    echo "qual será o nome do usuario?"
    read -r USUARIO
    echo "qual será o kernel?"
    echo "digite exatamente igual"
    echo "digite linux ou linux-lts ou algum outro mais não erre a escrita!"
    echo "e não digite nada além do kernel"
    read -r KERNEL
}

#formata os discos
formatar_disco (){
    

    mkfs.fat -F32 /dev/${DISCO}1
    mkswap /dev/${DISCO}2
    mkfs.ext4 /dev/${DISCO}3
    mkfs.ext4 /dev/${DISCO}4
}

#cria as pastas e monta os discos 
mountar_discos () {
    mount /dev/${DISCO}3 /mnt
    mkdir -p /mnt/boot/efi
    mkdir -p /mnt/home
    swapon /dev/${DISCO}2
    mount /dev/${DISCO}1 /mnt/boot/efi
    mount /dev/${DISCO}4 /mnt/home
    reflector
}

#instala sistema basico
install_pacstrap (){
    pacstrap /mnt base base-devel $KERNEL linux-firmware dhcpcd wpa_supplicant network-manager-applet networkmanager amd-ucode fwupd iwd iw wireless_tools dosfstools os-prober mtools dialog sudo nano vim htop reflector
}

#gerar tabela fstab
gerar_fstab () {
    genfstab -U -p /mnt >> /mnt/etc/fstab
}

#chroot
chroot_sistema () {
    
}

#acerta hora o relogio e teclado 
local_hora_teclado(){
    ln -sf /usr/share/zoneinfo/America/ Sao_Paulo /etc/localtime
    hwclock --systohc
    echo 'decomente o idioma'
    sleep 5 # espera 5 segundos
    vim /etc/locale.gen
    echo KEYMAP=br-abnt2 >> /etc/vconsole.conf
}

# Senha do root e criação do usuario e senha dele

senha_root_usuario () {
    echo "digite a senha do root"
    passwd
    useradd -m -g users -G wheel,storage,power -s /bin/bash $USUARIO
    passwd $USUARIO
    echo "descomente a linha wheel que tenha %wheel ALL=(ALL:ALL)ALL"
    EDITOR=nano visudo
    sleep 5
}

instalando_grub (){
    pacman -S grub efibootmgr
    grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch_grub --recheck
    grub-mkconfig -o /boot/grub/grub.cfg
}

instalando_xorg () {
    pacman -S  
}

instalando_ambiente_grafico_e_pacotes () {
    for package in "{pacman_list[@]}"; do
      pacman -S "$package" --noconfirm  
    done
    pacman -S 
}

enable_system_and_reboot () {
    systemctl enable lightdm
    systemctl enable Network manager
    systemctl enable bluetooth.service
    exit
    reboot
}



preparar_discos
formatar_disco
mountar_discos
install_pacstrap
gerar_fstab
cat <<REALEND > /mnt/next.sh
local_hora_teclado
senha_root_usuario
instalando_grub
instalando_ambiente_grafico_e_pacotes
enable_system


REALEND


arch-chroot /mnt sh next.sh