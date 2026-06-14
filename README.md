# AstroVim Full Stack — Setup Guide

Stack supportato: **PHP · Laravel · Python · Django · JavaScript · TypeScript · React · Next.js · SCSS · Bash**

---

## Requisiti minimi

| Strumento   | Versione minima | Note |
|-------------|----------------|------|
| macOS       | 12+            | Intel o Apple Silicon |
| Neovim      | 0.10+          | Si installa con lo script |
| Homebrew    | qualsiasi      | Installa da [brew.sh](https://brew.sh) |
| Git         | qualsiasi      | Già su macOS |
| Node.js     | 18+            | Consigliato via [nvm](https://github.com/nvm-sh/nvm) |
| Python      | 3.10+          | Già su macOS, o Homebrew |
| PHP         | 8.1+           | Si installa con lo script |

> **Apple Silicon (M1/M2/M3):** lo script usa `/usr/local/bin/php` (Homebrew Intel via Rosetta).
> Se il terminale è nativo arm64, cambia `PHP_BIN` nello script con il tuo percorso PHP arm64.

---

## Installazione in un comando

```bash
git clone <questo-repo> ~/terminal
cd ~/terminal
chmod +x install.sh
./install.sh
```

Lo script fa tutto in automatico:
1. Installa Neovim, lazygit, ripgrep, fd, shellcheck, shfmt, jq, PHP
2. Installa la Nerd Font (JetBrainsMono) per le icone
3. Installa tool npm: `typescript-language-server`, `intelephense`, `prettier`, `eslint`, `tailwindcss-language-server`
4. Installa tool pip: `black`, `isort`, `ruff`, `pylint`, `mypy`
5. Installa tool Composer: `phpcs`, `phpmd`, `php-cs-fixer`, `phpstan`
6. Copia la configurazione in `~/.config/nvim`
7. Scarica tutti i plugin (Lazy.nvim)

---

## Dopo l'installazione

### 1. Configura il terminale
Aggiungi al tuo `~/.zshrc` (o `~/.bashrc`):

```bash
# Composer global bin
export PATH="$HOME/.composer/vendor/bin:$PATH"

# Python user bin
export PATH="$HOME/Library/Python/3.12/bin:$PATH"

# Homebrew
export PATH="/usr/local/bin:$PATH"
```

Poi: `source ~/.zshrc`

### 2. Imposta la Nerd Font nel terminale
In **iTerm2:** Preferences → Profiles → Text → Font → `JetBrainsMono Nerd Font`
In **Terminal.app:** Preferenze → Profili → Font → `JetBrainsMono Nerd Font`

Senza la font, le icone appaiono come caratteri strani `?`.

### 3. Prima apertura di Neovim
```bash
nvim
```

Aspetta che Mason installi i LSP server (circa 2-3 minuti).
Puoi vedere lo stato con `:Mason`.

---

## Struttura della cartella

```
terminal/
├── install.sh          ← script installazione automatica
├── README.md           ← questa guida
├── KEYMAP.md           ← tutti i tasti utili
└── nvim-config/        ← configurazione completa AstroVim
    ├── init.lua
    ├── lazy-lock.json  ← versioni esatte dei plugin
    └── lua/
        ├── community.lua       ← AstroCommunity packs
        ├── lazy_setup.lua      ← bootstrap Lazy.nvim
        ├── polish.lua          ← autocommand + PATH
        └── plugins/
            ├── astrocore.lua   ← keymaps + opzioni + layout 3 pannelli
            ├── astrolsp.lua    ← configurazione LSP (PHP, Python, TS)
            ├── mason.lua       ← tool da installare (LSP, linters, formatters)
            ├── none-ls.lua     ← linters e formatters attivi
            ├── treesitter.lua  ← parser sintassi
            └── user.lua        ← plugin extra (LazyGit, XDebug, Docblock, ecc.)
```

---

## Plugin installati

### Linguaggi (via AstroCommunity)
| Pack | Cosa include |
|------|-------------|
| `pack.php` | intelephense LSP, phpcs, phpmd |
| `pack.python` | pyright LSP, black, isort, debugpy |
| `pack.typescript` | ts_ls, eslint, prettier, tsc |
| `pack.tailwindcss` | tailwindcss LSP, completamento classi |
| `pack.html-css` | html/css LSP, emmet |
| `pack.bash` | bash-language-server, shellcheck |
| `pack.json` | jsonls, SchemaStore |
| `pack.yaml` | yaml LSP, SchemaStore |
| `pack.markdown` | marksman LSP, preview |

### Plugin extra
| Plugin | Funzione |
|--------|---------|
| `lazygit.nvim` | UI Git completa (`Space g g`) |
| `diffview.nvim` | Diff visuale + storico (`Space g d`) |
| `neogit` | Git stile Magit |
| `vim-blade` | Sintassi Laravel Blade |
| `vim-doge` | Generatore docblock PHP/Python/JS (`Space d g`) |
| `nvim-dap` + `nvim-dap-ui` | Debug con breakpoint (F5/F10/F11) |
| `venv-selector.nvim` | Selezione virtualenv Python (`Space c v`) |
| `vscode-react-javascript-snippets` | Snippet JSX/TSX |
| `trouble.nvim` | Lista errori/diagnostics (`Space x x`) |
| `todo-comments.nvim` | Highlight TODO/FIXME/NOTE |

---

## Claude AI (avante.nvim)

Il plugin **avante.nvim** integra Claude direttamente in nvim come pannello laterale — simile a Cursor.

### 1. Ottieni l'API key

Vai su [console.anthropic.com](https://console.anthropic.com) → API Keys → Create Key.

### 2. Configura l'API key

Aggiungi al tuo `~/.zshrc` (o `~/.bashrc`):

```bash
export ANTHROPIC_API_KEY="sk-ant-api03-..."
```

Poi ricarica:
```bash
source ~/.zshrc
```

### 3. Usa Claude in nvim

| Tasto       | Azione |
|-------------|--------|
| `Space A a` | **Ask** — apri pannello e fai una domanda sul codice |
| `Space A e` | **Edit** — seleziona codice + chiedi una modifica |
| `Space A t` | **Toggle** — mostra/nasconde il pannello |
| `Space A ?` | Cambia modello (sonnet, opus, ecc.) |

**Esempio:** seleziona una funzione PHP in Visual mode → `Space A e` → scrivi *"aggiungi validazione e PHPDoc"* → Claude propone le modifiche → accetti con `]c` o rifiuti con `[c`.

---

## XDebug (PHP / Laravel)

### Configurazione php.ini
```ini
[xdebug]
zend_extension=xdebug.so
xdebug.mode=debug
xdebug.start_with_request=yes
xdebug.client_port=9003
xdebug.client_host=127.0.0.1
```

### Avvio debug in nvim
1. `F5` → seleziona **"Listen for XDebug (Laravel / PHP)"**
2. Fai la richiesta HTTP dal browser
3. nvim si ferma al breakpoint (impostato con `Space d b`)

---

## Format on save

Attivo automaticamente al salvataggio del file:

| Linguaggio | Formatter |
|-----------|-----------|
| Python | black (88 char) + isort |
| PHP | php-cs-fixer (PSR-12) |
| JS/TS/React | prettierd |
| SCSS/CSS | prettierd |
| Bash | shfmt |
| Lua | stylua |
| JSON/YAML/MD | prettierd |

---

## Keymap principali

Vedi **[KEYMAP.md](KEYMAP.md)** per la lista completa.

**Leader key = Spazio (Space)**

| Tasto | Azione |
|-------|--------|
| `Space e` | File tree (Neo-tree) |
| `Space f f` | Cerca file |
| `Space f g` | Cerca testo |
| `Space g g` | LazyGit |
| `Space w 3` | Layout 3 pannelli |
| `g r` | References (dove è richiamata la funzione) |
| `g d` | Go to definition |
| `K` | Documentazione hover |
| `F5` | Avvia debug |

---

## Aggiornamento plugin

Da dentro nvim:
```
:Lazy sync
```

Per aggiornare i tool Mason:
```
:MasonToolsUpdate
```
