#!/bin/bash
# Instalador de Claude Code y su entorno para macOS.
# Espeja al instalador de Windows (Instalador-Claude-SUMA-v2.2), pero con Homebrew.
#
#   bash instalar-mac.sh                 # perfil completo, preguntando antes
#   bash instalar-mac.sh --basico        # solo lo imprescindible
#   bash instalar-mac.sh --si            # sin preguntar
#   bash instalar-mac.sh --simulacion    # no instala nada, solo dice qué haría
#
# No borra ni modifica archivos del usuario. Lo único que escribe fuera de
# Homebrew es ~/.claude/settings.json (respaldando el anterior) y el árbol de
# carpetas de trabajo en ~/Documents.

set -u

PERFIL=completo
SIN_PREGUNTAR=0
SIMULACION=0
for a in "$@"; do
  case "$a" in
    --basico|--básico) PERFIL=basico ;;
    --completo) PERFIL=completo ;;
    --si|--sí|-y) SIN_PREGUNTAR=1 ;;
    --simulacion|--simulación|--dry-run) SIMULACION=1 ;;
    --ayuda|-h|--help)
      grep '^#' "$0" | sed 's/^# \{0,1\}//' | head -16; exit 0 ;;
    *) echo "opción desconocida: $a"; exit 2 ;;
  esac
done

RAIZ="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG="$RAIZ/config"
REGISTRO="$HOME/Library/Logs/instalador-claude-$(date +%Y%m%d-%H%M%S).log"
mkdir -p "$(dirname "$REGISTRO")"

# ─────────────────────────────────────────────────────────── presentación ──
V='\033[1;34m'; AM='\033[1;33m'; VE='\033[0;32m'; RO='\033[0;31m'; GR='\033[0;90m'; N='\033[0m'
titulo() { printf "\n${V}%s${N}\n%s\n" "$1" "$(printf '─%.0s' $(seq 1 ${#1}))"; }
paso()   { printf "  ${GR}·${N} %s\n" "$1"; }
ok()     { printf "  ${VE}✓${N} %s\n" "$1"; }
aviso()  { printf "  ${AM}!${N} %s\n" "$1"; }
falla()  { printf "  ${RO}✗${N} %s\n" "$1"; }
nota()   { printf "    ${GR}%s${N}\n" "$1"; }

RESUMEN=()
anotar() { RESUMEN+=("$1|$2|$3"); }   # estado|pieza|detalle

correr() {   # correr "descripción" comando...
  local desc="$1"; shift
  if [ "$SIMULACION" = 1 ]; then paso "[simulación] $desc"; return 0; fi
  paso "$desc"
  if "$@" >>"$REGISTRO" 2>&1; then return 0; fi
  return 1
}

hay() { command -v "$1" >/dev/null 2>&1; }

# ───────────────────────────────────────────────────────────── 1. revisión ──
clear
cat <<BANNER

  ┌────────────────────────────────────────────────┐
  │   Instalador de Claude Code para macOS         │
  │   Integral Marketing Agency                    │
  └────────────────────────────────────────────────┘

BANNER
printf "  Perfil: %s   ·   Registro: %s\n" "$PERFIL" "$REGISTRO"
[ "$SIMULACION" = 1 ] && aviso "Modo simulación: no se instala nada."

titulo "1. Qué hay en esta Mac"

ARQ="$(uname -m)"
MACOS="$(sw_vers -productVersion)"
ok "macOS $MACOS · $ARQ"
if [ "$ARQ" = "arm64" ]; then BREW_BIN=/opt/homebrew/bin/brew; else BREW_BIN=/usr/local/bin/brew; fi

# El bash de macOS es 3.2 y no tiene arreglos asociativos: se guarda cada dato
# en una variable con nombre armado (est_git, det_git…) y se lee con eval.
poner()  { eval "$1_$2=\"\$3\""; }
leer()   { eval "printf '%s' \"\${$1_$2:-}\""; }
estado() { leer est "$1"; }
detalle(){ leer det "$1"; }

revisar() {  # revisar clave comando
  local clave="$1" cmd="$2" v=""
  if hay "$cmd"; then
    v="$("$cmd" --version 2>/dev/null | head -1 | cut -c1-40)"
    poner est "$clave" 1; poner det "$clave" "$v"
    ok "$clave ya está (${v:-instalado})"
  else
    poner est "$clave" 0; poner det "$clave" ""
  fi
}

PIEZAS=(brew git claude node python uv rg bun playwright rtk markitdown superpowers gstack claude_app gdrive carpetas)
SOLO_COMPLETO=(node rg bun playwright rtk gstack)

revisar brew brew
revisar git git
revisar claude claude
revisar node node
revisar python python3
revisar uv uv
revisar rg rg
revisar bun bun
if hay npx && npx --no-install playwright --version >/dev/null 2>&1; then poner est playwright 1; ok "playwright ya está"; else poner est playwright 0; fi
revisar rtk rtk
if hay uv && uv tool list 2>/dev/null | grep -q markitdown; then poner est markitdown 1; ok "markitdown ya está"; else poner est markitdown 0; fi
if grep -qs superpowers "$HOME/.claude/settings.json"; then poner est superpowers 1; ok "plugin superpowers ya configurado"; else poner est superpowers 0; fi
if [ -d "/Applications/Claude.app" ]; then poner est claude_app 1; ok "Claude para escritorio ya está"; else poner est claude_app 0; fi
if [ -d "/Applications/Google Drive.app" ]; then poner est gdrive 1; ok "Google Drive ya está"; else poner est gdrive 0; fi
poner est carpetas 0

quiere() {
  local p="$1"
  if [ "$PERFIL" = basico ]; then
    for s in "${SOLO_COMPLETO[@]}"; do [ "$s" = "$p" ] && return 1; done
  fi
  return 0
}

PENDIENTES=()
for p in "${PIEZAS[@]}"; do
  quiere "$p" || continue
  [ "$(estado "$p")" = 1 ] && continue
  PENDIENTES+=("$p")
done

nombre() {
  case "$1" in
    brew) echo "Homebrew" ;; git) echo "Git" ;; claude) echo "Claude Code" ;;
    node) echo "Node.js" ;; python) echo "Python 3" ;; uv) echo "uv" ;;
    rg) echo "ripgrep" ;; bun) echo "bun" ;;
    playwright) echo "Playwright (navegador automatizado)" ;; rtk) echo "rtk" ;;
    markitdown) echo "markitdown (leer PDF y Word)" ;; superpowers) echo "plugin superpowers" ;;
    gstack) echo "gstack" ;; claude_app) echo "Claude para escritorio" ;;
    gdrive) echo "Google Drive" ;; carpetas) echo "tus carpetas de trabajo" ;;
    *) echo "$1" ;;
  esac
}

titulo "2. Qué se va a instalar"
if [ ${#PENDIENTES[@]} -eq 0 ]; then
  ok "No falta nada: esta Mac ya está completa."
else
  for p in "${PENDIENTES[@]}"; do printf "    · %s\n" "$(nombre "$p")"; done
  printf "\n  ${GR}Nada de esto borra ni modifica archivos tuyos.${N}\n"
  if [ "$SIN_PREGUNTAR" = 0 ] && [ "$SIMULACION" = 0 ]; then
    printf "\n  Enter para empezar, o escribe no y Enter para salir: "
    read -r r
    case "${r:-}" in n|no|N|NO) printf "\n  Listo, no se instaló nada.\n\n"; exit 0 ;; esac
    nota "Puede tardar entre 5 y 20 minutos según tu conexión. No cierres esta ventana."
  fi
fi

necesita() { for p in "${PENDIENTES[@]}"; do [ "$p" = "$1" ] && return 0; done; return 1; }

# ─────────────────────────────────────────────────────────── 3. Homebrew ──
titulo "3. Homebrew"
if necesita brew; then
  nota "Homebrew es el instalador de programas de macOS. Te va a pedir tu contraseña."
  if [ "$SIMULACION" = 1 ]; then paso "[simulación] instalar Homebrew"
  else
    paso "instalando Homebrew (puede pedir contraseña)"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" </dev/tty
  fi
  [ -x "$BREW_BIN" ] && eval "$("$BREW_BIN" shellenv)"
  if hay brew; then ok "Homebrew instalado"; anotar ok Homebrew "instalado ahora"
  else falla "No pude instalar Homebrew"; nota "https://brew.sh"; anotar error Homebrew "instalar a mano"; fi
else
  [ -x "$BREW_BIN" ] && eval "$("$BREW_BIN" shellenv)"
  anotar ok Homebrew "$(detalle brew)"
fi

brew_instalar() {  # brew_instalar formula "etiqueta" [--cask]
  local formula="$1" etiqueta="$2"; shift 2
  if [ "$SIMULACION" = 1 ]; then paso "[simulación] brew install $* $formula"; return 0; fi
  paso "instalando $etiqueta"
  brew install "$@" "$formula" >>"$REGISTRO" 2>&1
}

# ──────────────────────────────────────────────────────────────── 4. Git ──
titulo "4. Git"
if necesita git; then
  if brew_instalar git "Git" && hay git; then ok "Git instalado"; anotar ok Git "instalado ahora"
  else falla "No pude instalar Git"; nota "xcode-select --install también lo trae"; anotar error Git "instalar a mano"; fi
else anotar ok Git "$(detalle git)"; fi

# ──────────────────────────────────────────────────────── 5. Claude Code ──
titulo "5. Claude Code"
if necesita claude; then
  # El instalador nativo es el método recomendado y no necesita Node.js.
  if [ "$SIMULACION" = 1 ]; then paso "[simulación] curl -fsSL https://claude.ai/install.sh | bash"
  else
    paso "instalando Claude Code"
    curl -fsSL https://claude.ai/install.sh 2>>"$REGISTRO" | bash >>"$REGISTRO" 2>&1
    export PATH="$HOME/.local/bin:$PATH"
  fi
  if hay claude || [ -x "$HOME/.local/bin/claude" ]; then ok "Claude Code instalado"; anotar ok "Claude Code" "instalado ahora"
  else falla "No pude instalar Claude Code"; nota "https://claude.com/download"; anotar error "Claude Code" "instalar a mano"; fi
else anotar ok "Claude Code" "$(detalle claude)"; fi

# ─────────────────────────────────────────────── 6. herramientas de base ──
titulo "6. Herramientas"
instalar_simple() {  # instalar_simple clave formula etiqueta comando
  local clave="$1" formula="$2" etiqueta="$3" cmd="$4"
  necesita "$clave" || { anotar ok "$etiqueta" "$(detalle "$clave")"; return; }
  if brew_instalar "$formula" "$etiqueta" && { hay "$cmd" || [ "$SIMULACION" = 1 ]; }; then
    ok "$etiqueta instalado"; anotar ok "$etiqueta" "instalado ahora"
  else
    falla "No pude instalar $etiqueta"; anotar error "$etiqueta" "instalar a mano: brew install $formula"
  fi
}
instalar_simple python python@3.13 "Python 3" python3
instalar_simple uv uv "uv" uv
instalar_simple node node "Node.js" node
instalar_simple rg ripgrep "ripgrep" rg
instalar_simple bun oven-sh/bun/bun "bun" bun

# markitdown: lee PDF y Word. Va con uv para no ensuciar el Python del sistema.
if necesita markitdown; then
  if hay uv || [ "$SIMULACION" = 1 ]; then
    if correr "instalando markitdown" uv tool install "markitdown[all]"; then
      ok "markitdown instalado"; anotar ok markitdown "instalado ahora"
    else falla "No pude instalar markitdown"; anotar error markitdown "uv tool install 'markitdown[all]'"; fi
  else aviso "markitdown necesita uv"; anotar error markitdown "falta uv"; fi
fi

# Playwright: navegador automatizado. Descarga ~150 MB de navegador.
if necesita playwright; then
  if hay npx || [ "$SIMULACION" = 1 ]; then
    if correr "instalando Playwright y su navegador (puede tardar)" npx --yes playwright install chromium; then
      ok "Playwright instalado"; anotar ok Playwright "instalado ahora"
    else falla "No pude instalar Playwright"; anotar error Playwright "npx playwright install chromium"; fi
  else aviso "Playwright necesita Node.js"; anotar error Playwright "falta Node.js"; fi
fi

# rtk: ahorra tokens en las llamadas de Claude. Binario suelto desde GitHub.
if necesita rtk; then
  if [ "$ARQ" = arm64 ]; then RTK_ARCHIVO=rtk-aarch64-apple-darwin.tar.gz; else RTK_ARCHIVO=rtk-x86_64-apple-darwin.tar.gz; fi
  RTK_URL="https://github.com/rtk-ai/rtk/releases/latest/download/$RTK_ARCHIVO"
  if [ "$SIMULACION" = 1 ]; then paso "[simulación] bajar $RTK_URL"
  else
    paso "instalando rtk"
    TMP="$(mktemp -d)"
    if curl -fsSL "$RTK_URL" -o "$TMP/rtk.tar.gz" 2>>"$REGISTRO" && tar -xzf "$TMP/rtk.tar.gz" -C "$TMP" 2>>"$REGISTRO"; then
      mkdir -p "$HOME/.local/bin"
      find "$TMP" -type f -name rtk -perm -u+x -exec cp {} "$HOME/.local/bin/rtk" \; 2>>"$REGISTRO"
      chmod +x "$HOME/.local/bin/rtk" 2>/dev/null
      export PATH="$HOME/.local/bin:$PATH"
    fi
    rm -rf "$TMP"
  fi
  if hay rtk || [ "$SIMULACION" = 1 ]; then ok "rtk instalado"; anotar ok rtk "instalado ahora"
  else
    aviso "No pude instalar rtk (el instalador sigue igual)"
    nota "Descarga manual: https://github.com/rtk-ai/rtk/releases"
    anotar error rtk "bajar el binario a mano"
  fi
fi

# gstack: herramientas de desarrollo de Garry Tan. Necesita git + node + bun.
if necesita gstack; then
  if hay git && hay node; then
    if correr "instalando gstack" bash -c 'git clone --depth 1 https://github.com/garrytan/gstack.git "$HOME/.gstack" 2>/dev/null || git -C "$HOME/.gstack" pull --ff-only'; then
      ok "gstack descargado en ~/.gstack"; anotar ok gstack "en ~/.gstack"
    else falla "No pude descargar gstack"; anotar error gstack "git clone a mano"; fi
  else aviso "gstack necesita Git y Node.js"; anotar error gstack "faltan dependencias"; fi
fi

# ───────────────────────────────────────────── 7. configuración de Claude ──
titulo "7. Configuración de Claude Code"
DEST="$HOME/.claude/settings.json"
if [ "$SIMULACION" = 1 ]; then paso "[simulación] escribir $DEST"
else
  mkdir -p "$HOME/.claude"
  if [ -f "$DEST" ]; then
    RESP="$DEST.bak-$(date +%Y%m%d-%H%M%S)"
    cp "$DEST" "$RESP"; nota "Tu configuración anterior quedó en $(basename "$RESP")"
  fi
  if hay python3; then
    python3 - "$CONFIG/settings-base.json" "$DEST" <<'PY' >>"$REGISTRO" 2>&1
import json, sys
base = json.load(open(sys.argv[1]))
try:
    actual = json.load(open(sys.argv[2]))
except Exception:
    actual = {}
actual.update(base)          # la base manda; lo que el usuario tenía de más se conserva
json.dump(actual, open(sys.argv[2], "w"), indent=2, ensure_ascii=False)
PY
  else
    cp "$CONFIG/settings-base.json" "$DEST"
  fi
fi
if [ -f "$DEST" ] || [ "$SIMULACION" = 1 ]; then
  ok "settings.json listo (permisos, plugin superpowers y hook de rtk)"
  anotar ok "Configuración" "~/.claude/settings.json"
else
  falla "No pude escribir la configuración"; anotar error "Configuración" "$DEST"
fi

# ──────────────────────────────────────────── 8. aplicaciones de escritorio ──
titulo "8. Aplicaciones"
if necesita claude_app; then
  if brew_instalar claude "Claude para escritorio" --cask; then ok "Claude para escritorio instalado"; anotar ok "Claude escritorio" "instalado ahora"
  else aviso "No pude instalar Claude para escritorio"; nota "https://claude.com/download"; anotar error "Claude escritorio" "instalar a mano"; fi
fi
if necesita gdrive; then
  if brew_instalar google-drive "Google Drive" --cask; then ok "Google Drive instalado"; anotar ok "Google Drive" "instalado ahora"
  else aviso "No pude instalar Google Drive"; nota "https://www.google.com/drive/download/"; anotar error "Google Drive" "instalar a mano"; fi
fi

# ────────────────────────────────────────────────────────── 9. carpetas ──
titulo "9. Tus carpetas de trabajo"
BASE="$HOME/Documents"
CREADAS=0
if [ -f "$CONFIG/carpetas.txt" ]; then
  while IFS= read -r linea; do
    case "$linea" in ''|'#'*) continue ;; esac
    ruta="${linea%%|*}"; desc="${linea#*|}"
    ruta="$(echo "$ruta" | sed 's/[[:space:]]*$//')"
    [ "$desc" = "$linea" ] && desc=""
    destino="$BASE/$ruta"
    if [ "$SIMULACION" = 1 ]; then paso "[simulación] crear $destino"; continue; fi
    if [ ! -d "$destino" ]; then mkdir -p "$destino" && CREADAS=$((CREADAS+1)); fi
    if [ -n "$desc" ] && [ ! -f "$destino/LEEME.md" ]; then
      printf '# %s\n\n%s\n' "$(basename "$ruta")" "$(echo "$desc" | sed 's/^[[:space:]]*//')" > "$destino/LEEME.md"
    fi
  done < "$CONFIG/carpetas.txt"
  ok "Carpetas listas en $BASE ($CREADAS nuevas)"
  anotar ok "Carpetas" "$CREADAS nuevas en Documentos"
else
  aviso "No encontré config/carpetas.txt"; anotar error "Carpetas" "falta config/carpetas.txt"
fi

# ─────────────────────────────────────────────────────────── 10. resumen ──
titulo "10. Resumen"
ERRORES=0
for r in "${RESUMEN[@]}"; do
  IFS="|" read -r est_r pieza det_r <<EOF_R
$r
EOF_R
  if [ "$est_r" = ok ]; then printf "  ${VE}✓${N} %-22s %s\n" "$pieza" "$det_r"
  else printf "  ${RO}✗${N} %-22s %s\n" "$pieza" "$det_r"; ERRORES=$((ERRORES+1)); fi
done
printf "\n  Registro completo: %s\n" "$REGISTRO"
if [ "$ERRORES" -eq 0 ]; then
  printf "\n${VE}  Todo listo.${N} Abre la Terminal y escribe ${V}claude${N} para empezar.\n"
  nota "La primera vez te va a pedir iniciar sesión en tu cuenta de Claude."
else
  printf "\n${AM}  Terminó con %s cosa(s) pendiente(s).${N} Arriba dice cuál y cómo resolverla.\n" "$ERRORES"
fi
printf "\n"
