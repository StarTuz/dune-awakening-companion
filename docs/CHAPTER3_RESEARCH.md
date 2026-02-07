# Chapter 3 + Early 2026 Patch Research

This document summarizes confirmed changes around Chapter 3 and recent patches,
with implications for the Dune Awakening Companion App.

Last updated: 2026-02-06

## Sources
- Developer Update - January 2026 (Funcom): https://duneawakening.com/news/developer-update-january-2026/
- Chapter 3 Free Update Revealed (Funcom): https://duneawakening.com/news/chapter-3
- Public Test Client: Patch 1.3.0.0 (Funcom): https://duneawakening.com/news/public-test-client-patch-1-3-0-0/
- Patch 1.2.40.0 (Funcom): https://duneawakening.com/news/dune-awakening-1-2-40-0-patch-notes/
- Patch notes index (Funcom): https://duneawakening.com/news/patch-notes/

Notes:
- Official Chapter 3 live patch notes are not listed on the patch notes index
  at the time of writing. PTC 1.3.0.0 is the most detailed change list.
- PTC notes exclude Chapter 3 story continuation content to avoid spoilers.

## Confirmed Chapter 3 Highlights
- Release date: Feb 3, 2026.
- Taxes removed: base taxes are eliminated starting Chapter 3.
- Return packages: available for characters inactive 28+ days, claimable in-game.
- Revamped endgame: new progression loops, more solo and co-op activities.
- Landsraad redesign: missions now drive house progress and rewards.
- Specializations: five tracks (Crafting, Gathering, Exploration, Combat, Sabotage).
- Augmentations: new Augment Station for Plastanium tier unique gear.
- New weapons: Pyrocket, Dual Blades; rapier rework.
- New locations and repeatable testing stations with scaling difficulty.

## PTC 1.3.0.0 Mechanical Changes (Selected)
Progression and endgame:
- Tier 6 endgame redesign and deeper progression options.
- Specializations unlocked via Landsraad missions and Spice Melange traits.
- Augment Station and augments; augments reduce max durability and are permanent.

Landsraad:
- Missions are the core activity loop; house progress tied to missions.
- House Credits used to buy components for high-quality items.
- Faction ranks extended to 20 with new contracts and missions.

World and locations:
- 5 new repeatable testing stations with bosses and scaling difficulty.
- 4 new overland locations tied to Landsraad missions.
- Overland map UI and navigation improvements.
- Fuel and hydration mechanics removed from the Overland map (PTC).

Combat and items:
- New weapons (Pyrocket, Dual Blades) and rapier rework.
- Skill trees reset due to backend changes; respec costs scale with use.
- PvP scaling adjusted to make new endgame progression matter.

Vehicles and travel:
- Vehicle relocation via Vehicle Backup Tool (same map, same cost as recovery).
- Ornithopter pilots accept Solari from inventory and bank.

## Implications for the Companion App
Immediate:
- Tax tracking features must be deprecated or removed.
- Alerts, dashboards, and copy referencing taxes must be updated.

High value new features:
- Specialization tracking (per track XP, traits, and daily bonus cap).
- Landsraad mission planner (active missions, house progress, rewards).
- Augmentation planner (augment slots, durability tradeoffs, source tracking).

Medium value updates:
- New weapon catalog entries and build metadata.
- Overland map updates with new testing stations and mission locations.
- Return package checklist for returning players.

## Recommended App Roadmap (Draft)
Phase 1 (now):
- Remove tax references and tax alert flows.
- Add Chapter 3 change notice in settings or onboarding.

Phase 2:
- Add Specialization and Landsraad tracking features.
- Add Augmentation tracking and metadata.

Phase 3:
- Expand content database for new locations, testing stations, and weapons.
- Add "returning player" flow tied to return packages.

## Open Items to Verify
- Official Chapter 3 live patch notes once posted.
- Final values for specialization XP caps and augment limits on live servers.
- Any tax-related schema or data migrations needed in the app database.
