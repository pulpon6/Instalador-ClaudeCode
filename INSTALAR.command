#!/bin/bash
# Doble clic para instalar. Abre la Terminal en la carpeta correcta.
cd "$(dirname "$0")" || exit 1
bash mac/instalar-mac.sh "$@"
printf "\nPulsa Enter para cerrar esta ventana."
read -r _
