#!/usr/bin/env bash
set -e

# ─────────────────────────────────────────────────────────────────────────────
# AstroVim Full Stack — Install Script
# Stack: PHP/Laravel · Python/Django · JS/TS/React/Next.js · SCSS · Bash
# ─────────────────────────────────────────────────────────────────────────────

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
ok()   { echo -e "${GREEN}✓${NC} $1"; }
info() { echo -e "${BLUE}▶${NC} $1"; }
warn() { echo -e "${YELLOW}⚠${NC} $1"; }
fail() { echo -e "${RED}✗${NC} $1"; exit 1; }

echo ""
echo "╔══════════════════════════════════════════════════════╗"
echo "║        AstroVim Full Stack — Setup automatico        ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── 1. Prerequisiti di sistema ────────────────────────────────────────────────
info "Controllo prerequisiti..."

command -v brew &>/dev/null || fail "Homebrew non trovato. Installa da https://brew.sh"
command -v git  &>/dev/null || fail "git non trovato"
command -v node &>/dev/null || warn "Node.js non trovato — verrà installato via nvm"
command -v python3 &>/dev/null || fail "Python3 non trovato"

# ── 2. Neovim ─────────────────────────────────────────────────────────────────
info "Installazione Neovim..."
if command -v nvim &>/dev/null; then
  NVIM_VER=$(nvim --version | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
  ok "Neovim già installato: v$NVIM_VER"
else
  brew install neovim
  ok "Neovim installato"
fi

# ── 3. Dipendenze sistema (Homebrew) ──────────────────────────────────────────
info "Installazione tool di sistema..."
BREW_PKGS=(
  git lazygit ripgrep fd fzf
  shellcheck shfmt bash-language-server
  jq
  php          # PHP 8.x Intel (per Composer + tool PHP)
  node         # fallback se nvm non disponibile
  trivy        # scanner vulnerabilità container/IaC/dipendenze
)

for pkg in "${BREW_PKGS[@]}"; do
  if brew list "$pkg" &>/dev/null; then
    ok "$pkg già installato"
  else
    brew install "$pkg" && ok "$pkg installato"
  fi
done

# ── 4. Nerd Font (richiesta per icone) ────────────────────────────────────────
info "Installazione Nerd Font (JetBrainsMono)..."
if ls ~/Library/Fonts/JetBrainsMonoNerdFont* &>/dev/null 2>&1; then
  ok "JetBrainsMono Nerd Font già installata"
else
  brew tap homebrew/cask-fonts 2>/dev/null || true
  brew install --cask font-jetbrains-mono-nerd-font && ok "Font installata"
  warn "Imposta 'JetBrainsMono Nerd Font' nel tuo terminale per le icone"
fi

# ── 5. Node.js tools (npm global) ────────────────────────────────────────────
info "Installazione tool Node.js..."
NPM_PKGS=(
  "@typescript/native-preview"      # tsgo — TypeScript Native Preview (Go, ~10x più veloce)
  typescript-language-server        # fallback (disabilitato di default, usa tsgo)
  typescript
  oxlint                            # linter JS/TS ultra-veloce (Rust, >50x più veloce di ESLint)
  "@stoplight/spectral-cli"         # linter OpenAPI/Swagger (spec 2.0/3.0/3.1)
  commitizen                        # conventional commits wizard (cz commit)
  "cz-conventional-changelog"       # adapter conventional commits per commitizen
  "@tailwindcss/language-server"
  intelephense
  prettier
  eslint
  "@olrtg/emmet-language-server"
)

for pkg in "${NPM_PKGS[@]}"; do
  npm install -g "$pkg" --silent && ok "npm: $pkg"
done

# Configura commitizen globalmente (adapter conventional-changelog)
if [ ! -f "$HOME/.czrc" ]; then
  echo '{ "path": "cz-conventional-changelog" }' > "$HOME/.czrc"
  ok "commitizen: ~/.czrc configurato"
else
  ok "commitizen: ~/.czrc già presente"
fi

# ── 6. Python tools (pip) ────────────────────────────────────────────────────
info "Installazione tool Python..."
PIP_PKGS=(black isort ruff pylint mypy bandit)
for pkg in "${PIP_PKGS[@]}"; do
  pip3 install --quiet --user "$pkg" && ok "pip: $pkg"
done

# ── 7. Composer + tool PHP ────────────────────────────────────────────────────
info "Installazione Composer e tool PHP..."

PHP_BIN="/usr/local/bin/php"
if [ ! -x "$PHP_BIN" ]; then
  PHP_BIN=$(command -v php)
  warn "Usando php da: $PHP_BIN"
fi

if [ ! -f "/usr/local/bin/composer" ]; then
  curl -sS https://getcomposer.org/installer | "$PHP_BIN" -- \
    --install-dir=/usr/local/bin --filename=composer
  ok "Composer installato"
else
  ok "Composer già installato"
fi

COMPOSER_PKGS=(
  "squizlabs/php_codesniffer"
  "phpmd/phpmd"
  "friendsofphp/php-cs-fixer"
  "phpstan/phpstan"
)

for pkg in "${COMPOSER_PKGS[@]}"; do
  composer global require --quiet "$pkg" && ok "composer: $pkg"
done

# ── 8. Backup + copia config AstroVim ────────────────────────────────────────
info "Installazione configurazione AstroVim..."

if [ -d "$HOME/.config/nvim" ]; then
  BACKUP="$HOME/.config/nvim.backup-$(date +%Y%m%d-%H%M%S)"
  mv "$HOME/.config/nvim" "$BACKUP"
  warn "Config esistente spostata in: $BACKUP"
fi

cp -r "$SCRIPT_DIR/nvim-config" "$HOME/.config/nvim"
ok "Config AstroVim copiata in ~/.config/nvim"

# ── 9. Prima sincronizzazione plugin (headless) ───────────────────────────────
info "Download plugin Lazy.nvim (prima sincronizzazione)..."
TERM=xterm-256color nvim --headless "+Lazy! sync" +qa 2>/dev/null
ok "Plugin scaricati"

# ── 10. Riepilogo PATH ────────────────────────────────────────────────────────
echo ""
echo "╔══════════════════════════════════════════════════════╗"
echo "║                 Installazione completata             ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""
warn "Aggiungi queste righe al tuo ~/.zshrc o ~/.bashrc:"
echo ""
echo '  # Composer global'
echo '  export PATH="$HOME/.composer/vendor/bin:$PATH"'
echo ''
echo '  # Python user bin'
echo '  export PATH="$HOME/Library/Python/3.12/bin:$PATH"'
echo ''
echo '  # Homebrew (se non già presente)'
echo '  export PATH="/usr/local/bin:$PATH"'
echo ""
warn "Poi riapri il terminale e lancia: nvim"
warn "Alla prima apertura, attendi il completamento di :MasonToolsInstall"
echo ""
ok "Tutto pronto. Buon coding!"
