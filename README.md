# Instalador-ClaudeCode

Instalador del entorno de trabajo con Claude para Windows y Mac: Claude para
escritorio, Claude Code, Node.js, Python, markitdown, los plugins superpowers
y caveman, y una estructura de carpetas en Documentos.

## Versión actual: 2.3.0

| Archivo | Para quién |
|---|---|
| `Instalador-Claude-SUMA-Windows-v2.3.0.zip` | SUMA Beneficios, Windows |
| `Instalador-Claude-SUMA-Mac-v2.3.0.zip` | SUMA Beneficios, Mac |
| `Instalador-Claude-Generico-Windows-v2.3.0.zip` | Cualquier equipo, Windows. Sin marca y sin contacto de soporte |
| `Instalador-Claude-Generico-Mac-v2.3.0.zip` | Cualquier equipo, Mac. Sin marca y sin contacto de soporte |

### Cómo se usa

1. Descargá el zip que te corresponde y **extraelo**: botón derecho, «Extraer
   todo». El instalador no funciona si lo abrís desde adentro del zip.
2. Windows: abrí la carpeta `windows` y hacé doble clic en `INSTALAR.bat`.
   Mac: abrí la carpeta `mac` y hacé doble clic en `instalar-mac.command`.
3. No muevas la carpeta `config`: tiene que quedar al lado de `windows` o de
   `mac`, no adentro.

Cada zip trae una guía de usuario en HTML con el paso a paso.

### Novedades de la 2.3.0

- **Windows:** la 2.1.0 tenía un error de sintaxis de PowerShell 5.1 que
  impedía ejecutar cualquier línea del instalador. Quedó corregido.
- **winget:** se verifica ejecutándolo y, si no responde, se repara solo.
- **Planes B que no dependen de winget:**
  - Claude Code: descarga directa, verificada con SHA-256.
  - Claude para escritorio: el paquete MSIX oficial.
  - Node.js: una copia portátil, que no pide administrador.
- **`INSTALAR.bat`** ya no se borra a sí mismo cuando se ejecuta desde la
  copia local.
- **Plugin caveman** en los dos perfiles. Hace que Claude responda corto y
  gaste menos tokens.
- **Variante genérica**, sin la marca SUMA y sin contacto de soporte.

Las versiones anteriores siguen en el historial del repositorio.
