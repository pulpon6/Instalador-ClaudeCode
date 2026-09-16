# Instalador de Claude Code para macOS

Deja una Mac lista para trabajar con Claude Code: el programa, sus herramientas
y el árbol de carpetas de trabajo. Es el equivalente del instalador de Windows
(`pulpon6/Instalador-ClaudeCode`), pero con Homebrew.

## Uso

```bash
# doble clic en INSTALAR.command, o desde la Terminal:
bash mac/instalar-mac.sh                # perfil completo, preguntando antes
bash mac/instalar-mac.sh --basico       # sin Node, bun, ripgrep, Playwright, rtk ni gstack
bash mac/instalar-mac.sh --simulacion   # dice qué haría, sin instalar nada
bash mac/instalar-mac.sh --si           # sin preguntar
bash mac/desinstalar-mac.sh             # deshace la instalación
```

## Qué instala

Homebrew · Git · Claude Code · Node.js · Python 3 · uv · ripgrep · bun ·
Playwright · rtk · markitdown · gstack · Claude para escritorio · Google Drive ·
la configuración `~/.claude/settings.json` · y las carpetas de `config/carpetas.txt`.

## Qué NO toca

No borra ni modifica archivos del usuario. Lo único que escribe fuera de Homebrew
es `~/.claude/settings.json` —respaldando el anterior con fecha— y las carpetas de
trabajo dentro de `~/Documents`. El desinstalador tampoco borra carpetas ni archivos.

## Estructura

```
INSTALAR.command          doble clic para instalar
DESINSTALAR.command       doble clic para deshacer
GUIA-USUARIO-MAC.html     guía para la persona que lo instala (con botón Guardar PDF)
mac/instalar-mac.sh       el instalador
mac/desinstalar-mac.sh    el desinstalador
config/carpetas.txt       el árbol de carpetas — se edita acá, no en los scripts
config/settings-base.json configuración de Claude Code que se aplica
```

## Notas de implementación

- **Escrito para el bash 3.2 que trae macOS**: sin arreglos asociativos ni `readarray`.
  Los estados se guardan en variables con nombre armado (`est_git`, `det_git`) vía `eval`.
- **Idempotente**: revisa qué hay antes de instalar y se salta lo que ya está. Se puede
  volver a correr las veces que haga falta.
- **El registro completo** de cada corrida queda en `~/Library/Logs/instalador-claude-<fecha>.log`.
- **Claude Code se instala con el instalador nativo** (`claude.ai/install.sh`), que no
  necesita Node.js.
- **rtk** no está en Homebrew: se baja el binario de las releases de GitHub según la
  arquitectura (`aarch64` o `x86_64`).

## Pendiente de probar en una Mac limpia

Todo se verificó en una Mac que ya tenía casi todo instalado, más una corrida completa
en modo simulación. Falta probarlo en una Mac recién formateada, sobre todo: la instalación
de Homebrew (pide contraseña), la descarga de rtk y los dos `--cask` de las aplicaciones.
