# Documentation

## Why
High level design material lives here so new contributors can quickly understand the architecture. Keeping docs close to the code base avoids losing context over time.

## Responsibilities
- Provide architecture overviews and dependency diagrams.
- Maintain a glossary of deck-building and strategy terms.
- Record Architectural Decision Records (ADRs) for major changes.

## Structure
- `architecture.md` explains how managers interact and includes diagrams. Update it when adding or refactoring systems.
- `glossary.md` lists short definitions of important game terminology.
- `adr/` holds numbered ADR files that justify design choices such as chosen network protocol or UI toolkit.

Each document should be concise so the folder remains readable. When implementing a new feature, check if any diagrams need updates and add an ADR entry if the change alters the project's direction.

## Example Outline
```md
# architecture.md
- GameManager orchestrates SeasonManager and BoardManager.
- NetworkManager handles lobby then relays RPC to GameManager.
```

Thorough documentation saves time during onboarding and ensures gameplay behaviour is reproducible. Keep commit messages and ADRs in sync so there is a clear history of why systems exist.

Regularly review this folder when planning sprints. Outdated diagrams lead to confusion during playtesting and can slow down onboarding. Keeping notes accurate helps maintain design coherence across code and content.
