# Instalador-ClaudeCode

Instalador del entorno de trabajo con Claude para Windows y Mac: Claude para
escritorio, Claude Code, Node.js, Python, markitdown, los plugins superpowers
y caveman, GSD Core, y una estructura de carpetas en Documentos.

## Versión actual: 2.4.0

| Archivo | Para quién |
|---|---|
| `Instalador-Claude-SUMA-Windows-v2.4.0.zip` | SUMA Beneficios, Windows |
| `Instalador-Claude-SUMA-Mac-v2.4.0.zip` | SUMA Beneficios, Mac |
| `Instalador-Claude-Generico-Windows-v2.4.0.zip` | Cualquier equipo, Windows. Sin marca y sin contacto de soporte |
| `Instalador-Claude-Generico-Mac-v2.4.0.zip` | Cualquier equipo, Mac. Sin marca y sin contacto de soporte |

### Cómo se usa

1. Descargá el zip que te corresponde y **extraelo**: botón derecho, «Extraer
   todo». El instalador no funciona si lo abrís desde adentro del zip.
2. Windows: abrí la carpeta `windows` y hacé doble clic en `INSTALAR.bat`.
   Mac: abrí la carpeta `mac` y hacé doble clic en `instalar-mac.command`.
3. No muevas la carpeta `config`: tiene que quedar al lado de `windows` o de
   `mac`, no adentro.

Cada zip trae una guía de usuario en HTML con el paso a paso.

### Novedades de la 2.4.0

- **GSD Core** (`@opengsd/gsd-core`) en los dos perfiles y en Windows y Mac. Se
  instala con `npx @opengsd/gsd-core@latest --claude --global`. Exige
  **Node.js 24 o superior**: si el equipo tiene una versión más vieja, el
  instalador la actualiza (o avisa si no puede).
- **Nada depende de la Microsoft Store.** Si winget no responde, se repara por
  terminal con el módulo oficial `Microsoft.WinGet.Client` o, si falla, con los
  archivos de los releases de `microsoft/winget-cli` en GitHub.
- **Git, Python y ripgrep ya no dependen de winget.** Si winget falla,
  se descargan directo: Git y ripgrep de GitHub (verificados con su SHA-256) y
  Python de python.org (verificado con la firma de la Python Software
  Foundation). Todo por usuario, sin administrador.
- **Mac:** ripgrep también tiene descarga directa si no hay Homebrew.
- **Desinstalar** ahora también quita GSD Core.
- **RustDesk** actualizado de la 1.4.9 a la 1.5.0.

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

## Qué se instala

| Pieza | Perfil «Lo básico» | Perfil «Todo» |
|---|:---:|:---:|
| Claude para escritorio | ✓ | ✓ |
| Claude Code (terminal) | ✓ | ✓ |
| Git | ✓ | ✓ |
| Python 3 y uv | ✓ | ✓ |
| Node.js 24 o superior (lo usan caveman y GSD Core) | ✓ | ✓ |
| markitdown (para que Claude lea PDF, Word y Excel) | ✓ | ✓ |
| Plugin **superpowers** | ✓ | ✓ |
| Plugin **caveman** | ✓ | ✓ |
| **GSD Core** (flujo por fases, 72 skills) | ✓ | ✓ |
| Google Drive (necesita permiso de administrador) | ✓ | ✓ |
| Carpetas de trabajo en Documentos | ✓ | ✓ |
| bun, ripgrep, Playwright con Chromium | | ✓ |
| rtk (reduce los tokens de los comandos de terminal) | | ✓ |
| Skills de **gstack** | | ✓ |

Configuración que deja puesta: Claude Code no pide permiso para cada acción
(`bypassPermissions`), salvo para leer secretos (`.env`, `.ssh`, claves
privadas, `.pem`, `.kdbx`), que quedan bloqueados.

## Terminal o Claude Desktop: qué funciona dónde

Hay tres lugares donde se puede usar Claude, y no todo lo que instala este
paquete funciona en los tres:

- **Terminal:** Claude Code (`claude`) en la terminal.
- **Desktop, pestaña Code:** la pestaña *Code* de Claude para escritorio. Corre
  el mismo motor que la terminal, con su propia copia de Claude Code.
- **Desktop, chat:** la pestaña de chat normal de Claude para escritorio. Ahí
  **no se cargan** skills, plugins ni hooks: todo lo de este paquete es de
  Claude Code.

La documentación oficial dice que la pestaña Code y la terminal comparten
`CLAUDE.md`, `~/.claude/settings.json`, los **hooks** y los **skills**
([Claude Code Desktop](https://code.claude.com/docs/en/desktop#shared-configuration)).
Por eso casi todo funciona igual en las dos. Lo que cambia es qué necesita cada
pieza para correr.

| Pieza | Terminal | Desktop (pestaña Code) | Qué necesita / nota |
|---|:---:|:---:|---|
| **superpowers** (15 skills) | ✓ | ✓ | Solo instrucciones. En Desktop los plugins se administran desde su gestor gráfico; no están disponibles en sesiones WSL ni en la nube. |
| **caveman**: modo y skills de uso diario (`caveman`, `caveman-commit`, `caveman-review`, `caveman-compress`, `caveman-explore`, `cavecrew`, `investigate-first`, `surgical-patch`, `safe-refactor`, `lean-build`, `migration`, `verify-and-stop`, `caveman-help`, `caveman-stats`) | ✓ | ✓ | Los hooks `SessionStart` y `UserPromptSubmit` ejecutan `node`: tiene que estar en el PATH. |
| **caveman Cloud** (`caveman-setup`, `-discover`, `-optimize`, `-manage`, `-evidence-review`, `-learn`) | ✓ | ✓ | Requieren una cuenta de Caveman Cloud, en cualquier lugar. |
| **GSD Core**: skills `/gsd-*` (72) | ✓ | ✓ | Necesita Node 24+. Muchos usan `AskUserQuestion` para preguntar. |
| **GSD Core**: hooks (guardas de lectura/escritura, monitor de contexto) | ✓ | ✓ | Se guardan en `settings.json`, que es compartido. |
| **GSD Core**: barra de estado (statusline) | ✓ | No documentado | Es una barra de la terminal. La documentación de Desktop no la menciona; no la probamos. |
| **GSD Core**: `gsd-review`, `gsd-plan-review-convergence` | ✓ | ✓ | Piden revisión a otras IA por línea de comandos (`codex`, `gemini`, `coderabbit`, `opencode`, `qwen`, `cursor-agent`). **El instalador no instala ninguna**: hay que tenerla en el PATH. |
| **GSD Core**: `gsd-ultraplan-phase` (beta) | ✓ | No probado | Manda el plan a la nube de Claude Code y lo revisás en el navegador. |
| **gstack**: planificación y revisión (`office-hours`, `spec`, `autoplan`, `plan-*`, `review`, `cso`, `health`, `investigate`, `retro`, `ship`, `document-*`, `make-pdf`, `context-save`/`restore`, `learn`, `diagram`, `careful`, `guard`, `freeze`) | ✓ | ✓ | Usan `bash` y `bun`. `ship` y `land-and-deploy` usan `git` y `gh`. |
| **gstack**: navegador (`browse`, `qa`, `qa-only`, `scrape`, `benchmark`, `canary`, `design-review`, `devex-review`, `land-and-deploy`, `skillify`, `pair-agent`, `setup-browser-cookies`) | ✓ | ✓ | Usan el binario propio de gstack con Chromium (Playwright) desde la shell. No es el panel de navegador de Desktop. |
| **gstack**: `open-gstack-browser` | ✓ | ✓ | Abre una ventana de Chromium aparte. |
| **gstack**: `codex` | ✓ | ✓ | Necesita el CLI de OpenAI Codex instalado. |
| **gstack**: `ios-*` (5) | ✓ | ✓ | Solo Mac con Xcode. |
| **rtk**: binario `rtk` | ✓ | No aplica | Es un programa de línea de comandos. Solo se usa escribiéndolo en una terminal. |
| **rtk**: hook `rtk hook claude` | ✓ | ✓ | Reescribe los comandos que Claude ejecuta con la herramienta Bash (`git status` pasa a `rtk git status`). **No** actúa sobre `Read`, `Grep` ni `Glob`. `rtk` tiene que estar en el PATH que ve la app (ver abajo). |
| **markitdown, uv, Python, ripgrep** | ✓ | ✓ | Claude los usa por Bash: tienen que estar en el PATH. |

### Lo que Desktop no tiene

Según la [documentación oficial](https://code.claude.com/docs/en/desktop#whats-not-available-in-desktop),
estas funciones de la terminal no existen en la pestaña Code:

- `claude -p` / `--print` (uso sin interfaz, para scripts y automatización).
- Agent teams (equipos de agentes coordinados). Los workflows dinámicos sí.
- Comandos que abren un diálogo en la terminal (`/permissions`, `/config` con
  argumentos): responden `isn't available in this environment`.

Ningún skill de este paquete depende de ellas: revisamos los `SKILL.md` de
gstack y de GSD y no usan `claude -p`.

### El PATH en Desktop (el punto que más falla)

La documentación oficial indica que Desktop **no siempre hereda tu entorno de
shell**:

- **macOS:** al abrir la app desde el Dock o Finder, lee tu perfil de shell
  (por ejemplo `~/.zshrc` o `~/.bashrc`) para sacar el `PATH`.
- **Windows:** hereda las variables de usuario y de sistema, pero no lee los
  perfiles de PowerShell. El instalador escribe el PATH de usuario en el
  registro, así que alcanza.

⚠️ **Mac:** el instalador agrega `~/.local/bin` al PATH en **`~/.zprofile`**
(o `~/.bash_profile`). La documentación nombra `~/.zshrc`, y no confirma que
Desktop lea `~/.zprofile`. Si `node`, `rtk` o `rg` no se encuentran dentro de
Desktop, agregá esta línea a `~/.zshrc` y reiniciá la app:

```bash
export PATH="$HOME/.local/bin:$HOME/.bun/bin:$PATH"
```

Para probarlo en Desktop: abrí la pestaña Code, pedile que ejecute
`git status`, y después corré `rtk gain --history` en una terminal. Si el
comando figura como `rtk git status`, el hook funcionó.

### Cómo se validó esto

| Qué | Cómo | Resultado |
|---|---|---|
| Hooks, skills y settings compartidos | Documentación oficial de Claude Code Desktop | Confirmado |
| Funciones que Desktop no tiene | Documentación oficial | Confirmado |
| Comportamiento del PATH | Documentación oficial | Confirmado; no confirma `~/.zprofile` |
| Dependencias de cada skill | Lectura de los `SKILL.md` de gstack y GSD (comandos, CLIs, navegador) | Hecho |
| El hook de rtk reescribe comandos | `rtk hook check "git status"` devolvió `rtk git status` | Confirmado |
| Funcionamiento dentro de la app Desktop | No se probó ejecutando la app | **Pendiente** |
| Statusline de GSD en Desktop | No aparece en la documentación | **Pendiente** |

## Skills que se instalan

Se usan escribiendo `/nombre` en Claude Code, o Claude las activa solo cuando
corresponde. Las listas son las de cada proyecto al 01/10/2026: el instalador
baja la versión vigente de cada uno, así que con el tiempo pueden sumarse o
cambiar algunas.

### Plugin superpowers (los dos perfiles) — 15 skills

Origen: [obra/superpowers](https://github.com/obra/superpowers), por el marketplace oficial `anthropics/claude-plugins-official`.

| Skill | Para qué sirve |
|---|---|
| `brainstorming` | Explora la intención y los requisitos antes de crear algo nuevo. |
| `writing-plans` | Escribe un plan de implementación a partir de un pedido de varios pasos. |
| `executing-plans` | Ejecuta un plan paso a paso en la misma sesión. |
| `subagent-driven-development` | Ejecuta un plan repartiendo las tareas entre subagentes. |
| `dispatching-parallel-agents` | Lanza varias tareas independientes en paralelo. |
| `test-driven-development` | Primero el test, después el código. |
| `systematic-debugging` | Busca la causa raíz de un error antes de proponer un arreglo. |
| `verification-before-completion` | Exige verificar antes de dar algo por terminado. |
| `requesting-code-review` | Pide una revisión de código antes de integrar. |
| `receiving-code-review` | Evalúa con criterio las sugerencias de una revisión. |
| `using-git-worktrees` | Aísla el trabajo en un worktree de git. |
| `finishing-a-development-branch` | Decide cómo integrar una rama terminada. |
| `writing-skills` | Crea y prueba skills nuevas. |
| `using-superpowers` | Le enseña a Claude a buscar y usar estas skills. |
| `diagnosing-superpowers` | Analiza por qué una sesión salió mal. |

### Plugin caveman (los dos perfiles) — 20 skills y 3 subagentes

Origen: [juliusbrussee/caveman](https://github.com/juliusbrussee/caveman).
Viene activado: Claude responde corto y directo, con un 65 % menos de tokens
de salida. Para volver al modo normal, escribile `stop caveman` o `/caveman off`.

| Skill | Para qué sirve |
|---|---|
| `caveman` | El modo de respuestas comprimidas. Niveles: `lite`, `full`, `ultra` y `wenyan`. |
| `caveman-help` | Tarjeta de referencia con todos los modos y comandos. |
| `caveman-stats` | Tokens usados y ahorro estimado en la sesión. |
| `caveman-commit` | Mensajes de commit cortos, en formato Conventional Commits. |
| `caveman-review` | Comentarios de revisión de código en una línea: ubicación, problema y arreglo. |
| `caveman-compress` | Comprime archivos de memoria (`CLAUDE.md` y similares) para ahorrar tokens de entrada. |
| `caveman-explore` | Explora un repositorio en modo solo lectura. |
| `cavecrew` | Guía para delegar en los subagentes cavecrew. |
| `investigate-first` | Diagnostica fallas ambiguas antes de editar nada. |
| `surgical-patch` | Arreglos mínimos en la capa justa, con prueba de regresión. |
| `safe-refactor` | Reestructura código sin cambiar su comportamiento. |
| `lean-build` | Construye funciones nuevas evitando agregar de más. |
| `migration` | Migraciones reversibles de esquemas, APIs o dependencias. |
| `verify-and-stop` | Verifica que algo cumple lo pedido, sin ampliar el alcance. |
| `caveman-learn` | Aplica las mejoras de un reporte de consumo de tokens. |
| `caveman-discover` | Etiqueta los flujos de IA de un repositorio (Caveman Cloud). |
| `caveman-setup` | Conecta un repositorio al gateway de Caveman Cloud. |
| `caveman-evidence-review` | Revisa costos y métricas de Caveman Cloud. |
| `caveman-optimize` | Propone optimizaciones y las evalúa (Caveman Cloud). |
| `caveman-manage` | Administra experimentos de Caveman Cloud. |

Subagentes: `cavecrew-investigator` (ubica código), `cavecrew-builder`
(ediciones de 1 o 2 archivos) y `cavecrew-reviewer` (revisión de cambios).
Las skills de Caveman Cloud solo sirven con una cuenta de ese servicio.

### GSD Core (los dos perfiles) — 72 skills y 35 subagentes

Origen: [open-gsd/gsd-core](https://github.com/open-gsd/gsd-core) (paquete
npm `@opengsd/gsd-core`, continuación de get-shit-done). Se instala en
`~/.claude`. Es un flujo de trabajo por fases: se arranca con `/gsd-new-project`
y a partir de ahí Claude planifica, ejecuta y verifica cada fase. Para ver todos
los comandos: `/gsd-help`. Para actualizar: `/gsd-update`.

| Área | Skills |
|---|---|
| Arranque | `gsd-new-project`, `gsd-onboard` (proyecto existente), `gsd-map-codebase`, `gsd-ingest-docs`, `gsd-import`, `gsd-next` (te dirige al siguiente paso), `gsd-help` |
| Ciclo de cada fase | `gsd-discuss-phase`, `gsd-spec-phase`, `gsd-plan-phase`, `gsd-mvp-phase`, `gsd-execute-phase`, `gsd-verify-work`, `gsd-validate-phase`, `gsd-secure-phase`, `gsd-ship` |
| Rápidos y autónomos | `gsd-fast`, `gsd-quick`, `gsd-quick-batch`, `gsd-autonomous`, `gsd-manager` |
| Ideas | `gsd-explore`, `gsd-sketch`, `gsd-spike`, `gsd-capture` |
| Revisión y calidad | `gsd-code-review`, `gsd-review`, `gsd-plan-review-convergence`, `gsd-audit-fix`, `gsd-audit-uat`, `gsd-add-tests`, `gsd-ui-phase`, `gsd-ui-review`, `gsd-eval-review`, `gsd-ai-integration-phase`, `gsd-debug`, `gsd-forensics` |
| Hitos y proyecto | `gsd-new-milestone`, `gsd-complete-milestone`, `gsd-audit-milestone`, `gsd-milestone-summary`, `gsd-phase`, `gsd-review-backlog`, `gsd-cleanup`, `gsd-docs-update`, `gsd-extract-learnings` |
| Continuidad | `gsd-pause-work`, `gsd-resume-work`, `gsd-thread`, `gsd-workstreams`, `gsd-workspace`, `gsd-progress`, `gsd-stats`, `gsd-undo`, `gsd-pr-branch`, `gsd-inbox` |
| Memoria y conocimiento | `gsd-graphify`, `gsd-mempalace-capture`, `gsd-mempalace-recall`, `gsd-profile-user` |
| Configuración | `gsd-config`, `gsd-settings`, `gsd-surface`, `gsd-health`, `gsd-update`, y los atajos por área `gsd-ns-context`, `gsd-ns-ideate`, `gsd-ns-manage`, `gsd-ns-project`, `gsd-ns-review`, `gsd-ns-workflow` |

GSD Core agrega sus propios hooks a `~/.claude/settings.json` (control de
contexto, guardas de lectura y escritura, protección de `.env`). Es
independiente de caveman y de rtk.

### gstack (solo el perfil «Todo») — 56 skills

Origen: [garrytan/gstack](https://github.com/garrytan/gstack). Se instala en
`~/.claude/skills/gstack`.

| Área | Skills |
|---|---|
| Entrada | `gstack` (te dirige a la skill que corresponde), `gstack-upgrade` |
| Planificación | `office-hours`, `spec`, `autoplan`, `plan-ceo-review`, `plan-eng-review`, `plan-design-review`, `plan-devex-review`, `plan-tune` |
| Revisión y calidad | `review`, `cso` (auditoría de seguridad), `health`, `investigate`, `test-audit`, `deslop-shared-libs`, `devex-review`, `benchmark`, `benchmark-models` |
| QA y navegador | `qa`, `qa-only`, `browse`, `scrape`, `skillify`, `open-gstack-browser`, `setup-browser-cookies`, `pair-agent` |
| Diseño | `design-consultation`, `design-shotgun`, `design-html`, `design-review`, `diagram` |
| Publicar y desplegar | `ship`, `land-and-deploy`, `setup-deploy`, `canary`, `landing-report`, `document-release` |
| Documentos | `document-generate`, `make-pdf` |
| Seguridad de la sesión | `careful`, `guard`, `freeze`, `unfreeze` |
| Contexto y memoria | `context-save`, `context-restore`, `learn`, `retro`, `setup-gbrain`, `sync-gbrain` |
| iOS | `ios-qa`, `ios-fix`, `ios-design-review`, `ios-sync`, `ios-clean` |
| Otros | `codex` (usa el CLI de OpenAI Codex) |

### RustDesk

`rustdesk-1.5.0-x86_64.exe` (Windows, 64 bits) es el ejecutable oficial de
[rustdesk/rustdesk](https://github.com/rustdesk/rustdesk/releases/tag/1.5.0),
para dar soporte remoto. No lo usa el instalador: se entrega aparte. SHA-256:
`8555777215510d83d2d61c9dc984e4fcc838bd7e79f9d18a42585431f5e8bb47`.

Las versiones anteriores siguen en el historial del repositorio.
