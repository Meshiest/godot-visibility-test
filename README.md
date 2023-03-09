# Godot Visibility Test

## Expected Behavior

- host window sees all players
- other players see only themselves (public visibility is off)
- when a player jumps, their public visibility is toggled
- when a player's public visibility is on, other players can see their cube and movement

## Current Behavior

- host sees all players
- other players see all players but the host (public visibility is off)
- when a (non-host) player jumps, their public visibility is toggled
- when a player's public visibility is on, other players see their movement
