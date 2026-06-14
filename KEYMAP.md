# AstroVim — Keymap di riferimento

> **Leader key = Spazio (Space)**
> Premi Space in modalità normale per vedere il menu which-key con tutti i comandi.

---

## LSP — Navigazione codice

| Tasto        | Azione                                      |
|--------------|---------------------------------------------|
| `g r`        | References — dove viene richiamata          |
| `g d`        | Definition — dove è definita                |
| `g D`        | Declaration                                 |
| `g i`        | Implementation                              |
| `K`          | Hover doc — mostra la documentazione inline |
| `Space l r`  | Rinomina la funzione in tutto il progetto   |
| `Space l a`  | Code actions (fix suggeriti)                |
| `] d`        | Prossimo errore/diagnostica                 |
| `[ d`        | Errore/diagnostica precedente               |
| `Space l f`  | Format file                                 |

---

## File & Ricerca

| Tasto       | Azione                              |
|-------------|-------------------------------------|
| `Space e`   | Apri/chiudi file tree (Neo-tree)    |
| `Space o`   | Focus sul file tree                 |
| `Space f f` | Cerca file per nome (Telescope)     |
| `Space f g` | Cerca testo in tutti i file (grep)  |
| `Space f b` | Lista buffer (file aperti)          |
| `Space f r` | File recenti                        |
| `Space f h` | Cerca nei comandi help              |

---

## Buffer (file aperti)

| Tasto       | Azione                        |
|-------------|-------------------------------|
| `] b`       | Buffer successivo             |
| `[ b`       | Buffer precedente             |
| `Space b d` | Chiudi buffer corrente        |
| `Space b D` | Chiudi tutti i buffer         |

---

## Finestre & Layout

| Tasto        | Azione                                        |
|--------------|-----------------------------------------------|
| `Space w 3`  | Layout 3 pannelli (main 50% + top/bot 25%)    |
| `Tab`        | Switch tra pannello top-right e bottom-right  |
| `Ctrl h`     | Vai alla finestra sinistra                    |
| `Ctrl j`     | Vai alla finestra sotto                       |
| `Ctrl k`     | Vai alla finestra sopra                       |
| `Ctrl l`     | Vai alla finestra destra                      |
| `Ctrl ←`     | Riduci larghezza finestra                     |
| `Ctrl →`     | Aumenta larghezza finestra                    |
| `Ctrl ↑`     | Aumenta altezza finestra                      |
| `Ctrl ↓`     | Riduci altezza finestra                       |

---

## Git

| Tasto        | Azione                             |
|--------------|------------------------------------|
| `Space g g`  | LazyGit (UI completa)              |
| `Space g d`  | DiffView — diff visuale            |
| `Space g h`  | Storico file (git log visuale)     |
| `Space g D`  | Chiudi DiffView                    |
| `] g`        | Prossima modifica (hunk)           |
| `[ g`        | Modifica precedente (hunk)         |
| `Space g s`  | Stage hunk                         |
| `Space g r`  | Reset hunk                         |
| `Space g b`  | Git blame inline                   |

---

## Debug (DAP)

| Tasto        | Azione                              |
|--------------|-------------------------------------|
| `F5`         | Avvia / Continua debug              |
| `F10`        | Step over (salta dentro)            |
| `F11`        | Step into (entra nella funzione)    |
| `F12`        | Step out (esci dalla funzione)      |
| `Space d b`  | Toggle breakpoint                   |
| `Space d B`  | Breakpoint condizionale             |
| `Space d u`  | Toggle UI debug                     |

---

## Docblock (PHP / Python / JS)

| Tasto        | Azione                                        |
|--------------|-----------------------------------------------|
| `Space d g`  | Genera docblock sulla funzione/classe         |

---

## Diagnostics & Problemi

| Tasto        | Azione                                  |
|--------------|-----------------------------------------|
| `Space x x`  | Lista tutti gli errori (Trouble)        |
| `Space x X`  | Errori solo del file corrente           |
| `Space x s`  | Simboli del file                        |
| `Space x l`  | Definizioni LSP                         |
| `Space x q`  | Quickfix list                           |

---

## Terminale

| Tasto        | Azione                            |
|--------------|-----------------------------------|
| `Space t f`  | Apri terminale float              |
| `Space t h`  | Apri terminale orizzontale        |
| `Space t v`  | Apri terminale verticale          |
| `Ctrl \ `    | Toggle terminale                  |

---

## Movimento veloce (modalità normale)

| Tasto   | Azione                              |
|---------|-------------------------------------|
| `H`     | Vai all'inizio della riga           |
| `L`     | Vai alla fine della riga            |
| `Ctrl d`| Scorri metà pagina giù              |
| `Ctrl u`| Scorri metà pagina su               |
| `z z`   | Centra il cursore a schermo         |
| `%`     | Vai alla parentesi/tag corrispondente |

---

## Modal vim (promemoria)

| Modalità | Come entrarci          | Come uscire |
|----------|------------------------|-------------|
| Normal   | — (default)            | `Esc`       |
| Insert   | `i` (prima cursore)    | `Esc`       |
| Insert   | `a` (dopo cursore)     | `Esc`       |
| Insert   | `o` (riga nuova sotto) | `Esc`       |
| Visual   | `v` (carattere)        | `Esc`       |
| Visual   | `V` (riga intera)      | `Esc`       |
| Command  | `:`                    | `Esc`       |
