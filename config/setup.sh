#!/bin/bash

# Colores para logs
GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"

DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

## THIS IS FOR SOPLASHA REPO FOR HYPRLAND ##

REPO_NAME="solopasha/hyprland"
REPO_FILE="/etc/yum.repos.d/_copr:copr.fedorainfracloud.org:solopasha:hyprland.repo"

echo -e "\e[34m==> Activando repositorio COPR: $REPO_NAME...\e[0m"

if [ ! -f "$REPO_FILE" ]; then
    sudo dnf copr enable -y "$REPO_NAME"
else
    echo -e "\e[32m✓ Repositorio $REPO_NAME ya estaba habilitado.\e[0m"
fi

## THIS IS FOR DEPENDENCES ##

echo -e "${GREEN}==> Iniciando configuración de dotfiles de Hyprland...${RESET}"

REQUIRED_PACKAGES=(
  brightnessctl
  pavucontrol
  satty
  waybar
  swww
  git
  nautilus
  Hyprland
  waypaper
  kitty
  grim
  slurp
  swaync
  cmatrix
  rofi
)

echo -e "${GREEN}==> Verificando e instalando dependencias...${RESET}"

for pkg in "${REQUIRED_PACKAGES[@]}"; do
    if ! command -v $pkg &>/dev/null; then
        echo -e "${RED}✗ $pkg no encontrado. Instalando...${RESET}"
        sudo dnf install -y "$pkg"
        if command -v $pkg &>/dev/null; then
            echo -e "${GREEN}✓ $pkg instalado correctamente.${RESET}"
        else
            echo -e "${RED}✗ Error al instalar $pkg.${RESET}"
        fi
    else
        echo -e "${GREEN}✓ $pkg ya está instalado.${RESET}"
    fi

done

## THIS IS FOR COPY CONFIGS AND MKDIR ##

echo -e "${GREEN}==> Creando carpetas necesarias...${RESET}"

mkdir ~/.config/waybar/
mkdir ~/Pictures 
mkdir ~/Scripts

echo -e "${GREEN}==> Moviendo Archivos Y Descoprimineto Fuentes...${RESET}"

unzip $DIR/fonts/Agave.zip -d ~/.local/share/fonts
unzip $DIR/fonts/JetBrainsMono-2.304.zip -d ~/.local/share/fonts

cp $DIR/Hyprland/hyprland.conf ~/.config/hypr/hyprland.conf
cp $DIR/waybar/config.jsonc ~/.config/waybar
cp $DIR/waybar/style.css ~/.config/waybar

cp -r $DIR/Wallpapers ~/Pictures
cp -r $DIR/Icons ~/Pictures

cp $DIR/Scripts/screenscr.sh ~/Scripts
chmod +x ~/Scripts/screenscr.sh

echo -e "${GREEN}✔ Configuración completada desde $DIR${RESET}"
