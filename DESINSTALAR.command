#!/bin/bash
cd "$(dirname "$0")" || exit 1
bash mac/desinstalar-mac.sh "$@"
printf "\nPulsa Enter para cerrar esta ventana."
read -r _
