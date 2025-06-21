# 0001 Networking Choice

## Status
Accepted

## Context
Multiplayer matches need reliable delivery without excessive overhead. Godot ships with ENet support, which offers ordered, reliable UDP and works out of the box across desktop platforms.

## Decision
Use Godot's ENet API for the lobby and in-game RPCs. It keeps latency low and simplifies hosting, avoiding extra dependencies.

## Consequences
Peers must connect directly or via port forwarding. Web builds cannot join because they require WebRTC, but native clients remain lightweight and cross-platform.
