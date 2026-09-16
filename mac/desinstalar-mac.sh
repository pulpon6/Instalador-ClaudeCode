#!/bin/bash
# Quita lo que instaló instalar-mac.sh. NO borra tus carpetas de trabajo
# ni tus archivos: solo programas y la configuración de Claude Code.
#
#   bash desinstalar-mac.sh [--si] [--simulacion]
set -u
SIN_PREGUNTAR=0; SIMULACION=0
for a in "$@"; do case "$a" in --si|-y) SIN_PREGUNTAR=1;; --simulacion|--dry-run) SIMULACION=1;; esac; done
V='\033[1;34m'; RO='\033[0;31m'; VE='\033[0;32m'; GR='\033[0;90m'; N='\033[0m'
hay() { command -v "$1" >/dev/null 2>&1; }
printf "\n${V}Desinstalador de Claude Code (macOS)${N}\n\n"
printf "  Se quita: Claude Code, rtk, markitdown, gstack y la configuración ~/.claude/settings.json\n"
printf "  ${GR}NO se tocan: tus carpetas de Documentos, Homebrew, Git, Node, Python ni las apps de escritorio.${N}\n"
if [ "$SIN_PREGUNTAR" = 0 ] && [ "$SIMULACION" = 0 ]; then
  printf "\n  Escribe ${RO}BORRAR${N} y Enter para continuar: "; read -r r
  [ "${r:-}" = "BORRAR" ] || { printf "\n  No se tocó nada.\n\n"; exit 0; }
fi
quitar() { # quitar "descripción" comando...
  local d="$1"; shift
  if [ "$SIMULACION" = 1 ]; then printf "  ${GR}[simulación]${N} %s\n" "$d"; return; fi
  "$@" >/dev/null 2>&1 && printf "  ${VE}✓${N} %s\n" "$d" || printf "  ${GR}·${N} %s (no estaba)\n" "$d"
}
quitar "Claude Code"  bash -c 'rm -f "$HOME/.local/bin/claude"; rm -rf "$HOME/.claude/local"'
quitar "rtk"          rm -f "$HOME/.local/bin/rtk"
quitar "gstack"       rm -rf "$HOME/.gstack"
hay uv && quitar "markitdown" uv tool uninstall markitdown
if [ -f "$HOME/.claude/settings.json" ] && [ "$SIMULACION" = 0 ]; then
  mv "$HOME/.claude/settings.json" "$HOME/.claude/settings.json.retirado-$(date +%Y%m%d-%H%M%S)"
  printf "  ${VE}✓${N} settings.json guardado como .retirado-<fecha> (no se borró)\n"
fi
printf "\n  Listo. Tus carpetas de Documentos siguen intactas.\n\n"
