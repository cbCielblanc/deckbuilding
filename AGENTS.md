# AGENT INSTRUCTIONS

## 1 · Project context
| Item | Value |
|------|-------|
| **Project name** | Deck-Builder Roguelike |
| **Engine** | Godot 4.4.1 |
| **One-liner** | Seasonal deck-builder with dynamic **biomes**, **economy**, network lobby, AI, and modular UI. |

---

## 2 · Repository documentation map
> The agent **must load all READMEs below at start-up** and keep them in RAM.

| Folder | README | Purpose |
|--------|--------|---------|
| `scripts/` | `scripts/README.md` | Gameplay logic & singletons (`SeasonManager`, `BattleManager`, etc.). |
| `ui/` | `ui/README.md` | Node tree, themes, signal map, drag-and-drop. |
| `scenes/` | `scenes/README.md` | Scene hierarchy, camera flow, lobby → game transitions. |
| `data/` | `data/README.md` | JSON schemas (`card_data.json`), import pipeline. |
| `assets/` | `assets/README.md` | Art & licence notes (UI icons, card backs, audio). |
| `docs/` | `docs/README.md` | High-level architecture, glossary, ADRs. |

*(Add extra READMEs if new top-level folders appear.)*

---

## 3 · Agent boot sequence
1. **Load** every README above.  
2. **Extract** per folder: scope, public classes/functions (I/O), inter-module deps.  
3. Build an **in-memory index** → `{keyword ↦ README ↦ files}` for quick lookup.

---

## 4 · Handling a user request
1. Match keywords to README(s).  
2. Draft an answer from the README synthesis.  
3. If needed, load exact code blocks and refine.  
4. Reply with explanation / patch / diff.  
5. Propose README updates when code changes.

---

## 5 · Update rules
* Every code change **must** refresh the README of the affected folder.  
* Target **200-400 tokens** per README (split when larger) :contentReference[oaicite:0]{index=0}.  
* After refactors, regenerate dependency diagrams in `docs/architecture.md`.  
* Follow *Keep-a-Changelog* for `CHANGELOG.md` :contentReference[oaicite:1]{index=1}.

---

## 6 · Coding & docs conventions
| Topic | Rule |
|-------|------|
| **Folder naming** | lower-snake_case, singular ( `scenes/`, `scripts/` ) :contentReference[oaicite:2]{index=2} |
| **GDScript** | Explicit types for public APIs; avoid `?:` ternaries; use `Callable` in `connect()` (Godot 4) :contentReference[oaicite:3]{index=3} |
| **Autoloads** | Avoid naming collisions with `class_name` :contentReference[oaicite:4]{index=4} |
| **README template** | Title → Why → Responsibilities → Key API table → Examples. |
| **Versioning** | Semantic Versioning + Keep-a-Changelog :contentReference[oaicite:5]{index=5} |

---

## 7 · Quick example
```text
Q: “Drag-and-drop de carte cassé”  
→ agent repère `ui/README.md`, ·CardButton· section → charge `card_button.gd`, voit signal manquant, renvoie patch + README diff.
```

### Key improvements
* **Folder list reflects reality** (`scripts/`, `ui/`, `scenes/`, `data/`, `assets/`, `docs/`).
* Tight **200-token** sections keep each README digestible :contentReference[oaicite:6]{index=6}.
* Embeds Godot-4-specific advice on signals, autoload conflicts, and folder hygiene :contentReference[oaicite:7]{index=7}.
* Adds explicit link to *Keep-a-Changelog* & SemVer conventions :contentReference[oaicite:8]{index=8}.
```

