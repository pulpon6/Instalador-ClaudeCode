# CAMBIOS

## v1.0 — 2026-09-15

Primera versión. Equivalente para macOS del instalador de Windows
`Instalador-Claude-SUMA-v2.2` (repositorio `pulpon6/Instalador-ClaudeCode`).

- `mac/instalar-mac.sh`: revisión previa, perfiles `completo` y `basico`, modo
  `--simulacion`, registro a archivo y resumen final con lo que quedó pendiente.
- `mac/desinstalar-mac.sh`: quita Claude Code, rtk, gstack y markitdown; deja las
  carpetas y los archivos del usuario intactos, y la configuración anterior renombrada.
- `INSTALAR.command` / `DESINSTALAR.command` para doble clic desde Finder.
- `GUIA-USUARIO-MAC.html` con el branding de Integral Marketing y botón Guardar PDF.
- `config/carpetas.txt` con el árbol `Trabajo/` genérico (el de Windows usaba `SUMA/`).

Diferencias con el de Windows, y por qué:

- **Homebrew en lugar de winget.** Es el equivalente en macOS y no necesita permisos
  de administrador salvo en su propia instalación.
- **Sin Git Bash**: macOS ya trae bash y zsh.
- **markitdown con `uv tool install`**, igual que en Windows, para no ensuciar el
  Python del sistema (en macOS además está protegido y `pip install` global falla).
- **rtk desde las releases de GitHub**: no está publicado en Homebrew.
