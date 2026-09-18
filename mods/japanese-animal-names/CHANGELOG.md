# Changelog

## 1.4.0 — 2026-09-18

- Added `enabled` to switch Japanese random names on or off without removing
  the MOD. Disabled mode leaves the game's native English pools untouched.
- Split built-in Japanese candidates into selectable Pet Style, Sweets,
  Season & Weather, Nature, and Color-Inspired groups.
- Added the optional `custom_names` group for user-added candidates.
- Added safe migration for v1.3.0 settings. A user-edited legacy list is
  retained as Custom names without adding unwanted built-in candidates.
- Removed the old static Fiddle name-pool replacement so `enabled: false`
  genuinely leaves the game's native English candidates unchanged.

## 1.3.0 — 2026-08-23

- Added a user-editable JSON name list through MMAPI config storage.
- The first loaded save creates `mod_data/japanese_animal_names/japanese_animal_names.json`.
- Hiragana, kanji, katakana, and other short names can be mixed in one shared list.

## 1.2.0 — 2026-08-22

- Replaced both pools with one shared Japanese-only pool of 77 names.
- Revised names around pet names, sweets, seasons/nature, and Japanese color-name inspirations.
- Kept every candidate between 2 and 5 Japanese characters.

## 1.1.0 — 2026-08-22

- Expanded to 100 Japanese names per sex.
- Names are limited to 2–5 Japanese characters.
- Added food, nature, seasonal, katakana, and Mistria-inspired name variations.
- Kept a shared group of names across both pools.

## 1.0.0 — 2026-08-22

- Initial release.
- Replaces the game's random animal-name pools with 90 Japanese names.
- Covers every ranch animal and pet that uses the shared naming screen.
