# AstroVim Full Stack — Setup Guide

Stack supportato: **PHP · Laravel · Python · Django · JavaScript · TypeScript · React · Next.js · Vue 2 · SCSS · Bash · Terraform · Kubernetes · Docker**

---

## Requisiti minimi

| Strumento   | Versione minima | Note |
|-------------|----------------|------|
| macOS       | 12+            | Intel o Apple Silicon |
| Neovim      | 0.11+          | Si installa con lo script |
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
1. Installa Neovim, lazygit, ripgrep, fd, shellcheck, shfmt, jq, PHP, trivy
2. Installa la Nerd Font (JetBrainsMono) per le icone
3. Installa tool npm (vedi sezione sotto per i dettagli)
4. Installa tool pip: `black`, `isort`, `ruff`, `pylint`, `mypy`, `bandit`
5. Installa tool Composer: `phpcs`, `phpmd`, `php-cs-fixer`, `phpstan`
6. Copia la configurazione in `~/.config/nvim`
7. Scarica tutti i plugin (Lazy.nvim)

---

## Tool npm richiesti

Alcuni plugin richiedono binari npm installati **globalmente**. Lo script `install.sh` li installa in automatico, ma se aggiungi la config su una macchina nuova esegui:

```bash
npm install -g \
  @typescript/native-preview \
  typescript-language-server \
  typescript \
  oxlint \
  @stoplight/spectral-cli \
  @anthropic-ai/claude-code \
  @tailwindcss/language-server \
  intelephense \
  prettier \
  eslint \
  @olrtg/emmet-language-server
```

| Pacchetto npm | Usato da | Note |
|---|---|---|
| `@typescript/native-preview` | **tsgo LSP** | TypeScript Native Preview — server Go ~10x più veloce. Fornisce il binario `tsgo` |
| `typescript-language-server` | ts_ls LSP (fallback) | Disabilitato di default, mantenuto come fallback |
| `typescript` | tsgo / ts_ls | Libreria TypeScript richiesta dai server |
| `oxlint` | **oxlint LSP** | Linter JS/TS ultra-veloce in Rust |
| `@anthropic-ai/claude-code` | **claudecode.nvim** | CLI ufficiale Claude Code. Fornisce il binario `claude` |
| `@tailwindcss/language-server` | Tailwind LSP | Completamento classi Tailwind |
| `intelephense` | PHP LSP | Language server PHP |
| `@stoplight/spectral-cli` | **Spectral** | Linter OpenAPI/Swagger — attivo su file con `openapi:` o `swagger:` |
| `commitizen` + `cz-conventional-changelog` | **Conventional commits** | Wizard interattivo per commit semantici (`Space g c`) |
| `prettier` / `eslint` | Formatter / linter JS | Usati da none-ls come fallback |
| `@olrtg/emmet-language-server` | Emmet LSP | Completamento HTML/JSX |

> **Verifica installazione:** dopo `npm install -g`, controlla che i binari siano nel PATH:
> ```bash
> which tsgo && which oxlint && which claude && which spectral
> ```
> Se non vengono trovati, aggiungi la cartella `node_modules/.bin` globale al PATH nel tuo `~/.zshrc`.

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
            ├── astrolsp.lua    ← configurazione LSP
            ├── mason.lua       ← tool da installare (LSP, linters, formatters)
            ├── none-ls.lua     ← linters e formatters attivi
            ├── treesitter.lua  ← parser sintassi
            └── user.lua        ← plugin extra
```

---

## Plugin installati

### Linguaggi (via AstroCommunity)
| Pack | Cosa include |
|------|-------------|
| `pack.php` | intelephense LSP, phpcs, phpmd |
| `pack.python` | pyright LSP, black, isort, debugpy |
| `pack.typescript` | ts_ls, eslint, prettier, tsc |
| `pack.vue` | vue-language-server (Volar), treesitter Vue |
| `pack.tailwindcss` | tailwindcss LSP, completamento classi |
| `pack.html-css` | html/css LSP, emmet |
| `pack.bash` | bash-language-server, shellcheck |
| `pack.json` | jsonls, SchemaStore |
| `pack.yaml` | yaml LSP, SchemaStore (rileva k8s manifests) |
| `pack.markdown` | marksman LSP, preview |
| `pack.terraform` | terraform-ls, tflint, syntax HCL |
| `pack.docker` | dockerfile LSP, hadolint |
| `pack.sql` | SQL LSP, completamento |
| `pack.full-dadbod` | vim-dadbod UI — MySQL, PostgreSQL, SQLite |

### LSP aggiuntivi (non Mason)
| Server | Funzione | Richiede |
|--------|---------|---------|
| `tsgo` | TypeScript Native Preview — Go, ~10x più veloce di ts_ls | `npm i -g @typescript/native-preview` |
| `oxlint` | Linter JS/TS ultra-veloce in Rust | `npm i -g oxlint` |

### Plugin extra
| Plugin | Funzione |
|--------|---------|
| `lazygit.nvim` | UI Git completa (`Space g g`) |
| `diffview.nvim` | Diff visuale + storico (`Space g d`) |
| `gitgraph.nvim` | Git tree — grafico branch e commit (`Space g l`) |
| `neogit` | Git stile Magit |
| `kulala.nvim` | REST client — esegui richieste HTTP da file `.http` (`Space R s`) |
| `vim-blade` | Sintassi Laravel Blade |
| `vim-doge` | Generatore docblock PHP/Python/JS (`Space d g`) |
| `nvim-dap` + `nvim-dap-ui` | Debug con breakpoint (F5/F10/F11) |
| `venv-selector.nvim` | Selezione virtualenv Python (`Space c v`) |
| `vscode-react-javascript-snippets` | Snippet JSX/TSX |
| `trouble.nvim` | Lista errori/diagnostics (`Space x x`) |
| `todo-comments.nvim` | Highlight TODO/FIXME/NOTE |
| `overseer.nvim` | Task runner — Makefile, npm scripts, ecc. (`:OverseerRun`) |

### AI
| Plugin | Funzione | Richiede |
|--------|---------|---------|
| `avante.nvim` | Chat Claude inline nel editor (`Space a a`) | `ANTHROPIC_API_KEY` |
| `claudecode.nvim` | Claude Code CLI integrato via MCP (`Space c c`) | `npm i -g @anthropic-ai/claude-code` |

### Security
| Tool | Linguaggio | Trigger | Cosa trova |
|------|-----------|---------|-----------|
| `semgrep` | Tutti | Al salvataggio | OWASP Top 10: injection, XSS, path traversal… |
| `bandit` | Python | Al salvataggio | Hash deboli, subprocess unsafe, credenziali hardcoded |
| `phpstan` | PHP | Al salvataggio | Analisi statica (richiede `phpstan.neon` nel progetto) |
| `trivy` | Container/IaC/deps | Terminale | CVE su filesystem, immagini Docker, Terraform |

> **Trivy** si usa da terminale: `trivy fs .` — scansiona l'intero progetto.

### UI
| Plugin | Funzione | Default |
|--------|---------|---------|
| `noice.nvim` | Cmdline e notifiche floating | ✅ attivo |
| `bufferline.nvim` | Tab con stili (slant, arrows…) | ✅ attivo |
| `dropbar.nvim` | Breadcrumb nella winbar (`Space b p` per pick) | ✅ attivo |
| `satellite.nvim` | Scrollbar con marker diagnostics/git | ✅ attivo |
| `hlchunk.nvim` | Highlight blocco codice corrente | ✅ attivo |
| `nvim-colorizer.lua` | Anteprima colori CSS/hex inline | ✅ attivo |
| `rainbow-delimiters.nvim` | Parentesi colorate per livello | ✅ attivo |
| `nvim-ufo` | Folding migliorato (`z R/M/K`) | ✅ attivo |
| `incline.nvim` | Nome file floating per ogni finestra | ✅ attivo |
| `zen-mode.nvim` | Focus mode — nasconde tutto (`Space u z`) | ✅ attivo |
| `twilight.nvim` | Oscura il codice fuori dal blocco corrente (`Space u t`) | ✅ attivo |
| `mini.animate` | Animazioni fluide per scroll/resize/cursore | ✅ attivo |
| `smear-cursor.nvim` | Animazione fluida del cursore | ❌ disattivato |

> Per attivare/disattivare i plugin UI: modifica `enabled = true/false` in `community.lua` o `user.lua`, poi `:Lazy sync`.

---

## Claude AI

Sono installati **due** plugin complementari per Claude:

| | `avante.nvim` | `claudecode.nvim` |
|---|---|---|
| Tipo | Chat inline nel editor | Terminale Claude Code CLI |
| Contesto | Manuale | Automatico via MCP (vede file aperti, selezioni, diagnostics) |
| Uso ideale | Generazione rapida inline | Sessioni lunghe, refactoring complessi |

### Configurazione API key (entrambi la richiedono)

Aggiungi al tuo `~/.zshrc`:

```bash
export ANTHROPIC_API_KEY="sk-ant-api03-..."
```

### Keymaps avante.nvim

| Tasto       | Azione |
|-------------|--------|
| `Space a a` | **Ask** — apri pannello Claude |
| `Space a e` | **Edit** — modifica il codice selezionato |
| `Space a t` | **Toggle** — mostra/nasconde il pannello |

### Keymaps claudecode.nvim

| Tasto       | Azione |
|-------------|--------|
| `Space c c` | Toggle terminale Claude Code |
| `Space c b` | Aggiungi buffer corrente al contesto |
| `Space c s` | Invia selezione visuale a Claude |
| `Space c y` | Accetta diff proposto da Claude |
| `Space c n` | Rifiuta diff |
| `Space c R` | Riprendi sessione (`--resume`) |

---

## Database (vim-dadbod)

Apri la UI con `:DBUI` e aggiungi una connessione:

| Database | Connection string |
|----------|------------------|
| MySQL | `mysql://user:password@127.0.0.1:3306/dbname` |
| PostgreSQL | `postgresql://user:password@127.0.0.1:5432/dbname` |
| SQLite | `sqlite:///path/to/file.db` |

Naviga le tabelle, scrivi query in un buffer SQL ed eseguile con `<Leader>S`.

---

## REST client (kulala.nvim)

Crea un file `api.http` con le richieste:

```http
GET https://api.example.com/users
Content-Type: application/json

###

POST https://api.example.com/users
Content-Type: application/json

{ "name": "Mario" }
```

| Tasto | Azione |
|-------|--------|
| `Space R s` | Esegui richiesta sotto il cursore |
| `Space R a` | Esegui tutte le richieste del file |
| `Space R n/p` | Prossima / precedente richiesta |
| `Space R i` | Ispeziona richiesta espansa |
| `Space R c` | Copia come cURL (importabile in Postman) |

> Postman può importare direttamente i file `.http`: *Import → file*.

---

## Conventional Commits (commitizen)

Commitizen guida la scrittura di commit semantici nel formato `tipo(scope): descrizione`.

### Prerequisiti

```bash
npm install -g commitizen cz-conventional-changelog
echo '{ "path": "cz-conventional-changelog" }' > ~/.czrc
```

### Uso

`Space g c` apre il wizard interattivo nel terminale:

```
? Select the type of change:
❯ feat:     A new feature
  fix:      A bug fix
  docs:     Documentation only changes
  style:    Formatting, no logic change
  refactor: Code change, no new feature or fix
  perf:     Performance improvement
  test:     Adding or updating tests
  chore:    Build process or tooling changes

? What is the scope of this change? (e.g. auth, api, ui)
  auth

? Write a short description:
  add JWT refresh token

? Is there a breaking change? No

→ Commit: feat(auth): add JWT refresh token
```

### Tipi di commit

| Tipo | Quando usarlo |
|------|--------------|
| `feat` | Nuova funzionalità |
| `fix` | Correzione di un bug |
| `docs` | Solo documentazione |
| `style` | Formattazione (spazi, virgole) — nessuna logica |
| `refactor` | Refactoring senza nuove feature o fix |
| `perf` | Miglioramento performance |
| `test` | Aggiunta o modifica test |
| `chore` | Build, dipendenze, configurazione CI |
| `revert` | Rollback di un commit precedente |

### Integrazione per progetto

Per configurare commitizen in un singolo progetto (invece di globale):

```bash
cd tuo-progetto
npm init -y
npx commitizen init cz-conventional-changelog --save-dev --save-exact
```

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
| JS/TS/React/Vue | prettierd |
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
| `Space g c` | Conventional commit (commitizen wizard) |
| `Space g l` | Git graph (branch tree) |
| `Space w 3` | Layout 3 pannelli |
| `Space b p` | Breadcrumb pick (dropbar) |
| `Space u z` | Zen mode |
| `Space u t` | Twilight (focus blocco) |
| `Space R s` | HTTP send request (kulala) |
| `g r` | References (dove è richiamata la funzione) |
| `g d` | Go to definition |
| `K` | Documentazione hover |
| `F5` | Avvia debug |
| `z R` | Apri tutti i fold (ufo) |
| `z M` | Chiudi tutti i fold (ufo) |

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
