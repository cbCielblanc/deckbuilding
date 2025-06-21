# Documentation

## Why
High level design material lives here so new contributors can quickly understand the architecture. Keeping docs close to the code base avoids losing context over time.

## Responsibilities
- Provide architecture overviews and dependency diagrams.
- Maintain a glossary of deck-building and strategy terms.
- Record Architectural Decision Records (ADRs) for major changes.

## Structure
- `architecture.md` outlines how managers and scenes connect and includes small diagrams. Update it whenever systems change.
- `glossary.md` offers brief definitions of important game terms so discussions stay consistent.
- `adr/` stores numbered decision records, beginning with `0001-networking-choice.md` which documents the ENet stack.

Each document should be concise so the folder remains readable. When implementing a new feature, check if any diagrams need updates and add an ADR entry if the change alters the project's direction.


Thorough documentation saves time during onboarding and ensures gameplay behaviour is reproducible. Keep commit messages and ADRs in sync so there is a clear history of why systems exist.

Regularly review this folder when planning sprints. Outdated diagrams lead to confusion during playtesting and can slow down onboarding. Keeping notes accurate helps maintain design coherence across code and content.

## Usage
Consult these documents before major refactors or feature additions. They act as the project's reference point for architecture and terminology.
