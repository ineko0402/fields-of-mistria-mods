# Changelog

## 1.8.2 — 2026-09-22

- Register the startup name-pool application once through the MOD's latched registration path.
- Declare the required `ui.menu_opened` hook for clearer MOMI compatibility checks.

## 1.8.1 — 2026-09-19

- Fixed saving an edited name from the native naming popup. The popup is now
  passed explicitly to its Confirm callback, as MOMI callbacks do not retain
  local variables from the function that created them.

## 1.8.0 — 2026-09-19

- Replaced the experimental Animal Journal dice button with the game's native
  animal-naming popup when editing an existing animal's name.
- Added the enabled-by-default `use_naming_popup` setting to restore the
  original text-only rename popup if preferred.

## 1.7.2 — 2026-09-19

- Fixed the dice button flickering by removing its competing hover target.
  The name row now handles its dice-area click directly.

## 1.7.1 — 2026-09-19

- Fixed the Animal Journal dice button being visually present but receiving no
  mouse click because the overlapping name row handled the click first.

## 1.7.0 — 2026-09-19

- Added a dice button beside the Animal Journal name field. It instantly
  rerolls the selected pet, mount, or ranch animal's name from enabled
  Japanese candidate groups.

## 1.6.0 — 2026-09-19

- Added チロ to Pet Style.
- Replaced Season & Weather and Nature with the new 21-name Season & Nature
  group, including ヒナタ, イズミ, シズク, ホクト, シグレ, and カスミ.
- Added the 24-name Flower & Plant group.
- Expanded Color-Inspired to 25 names, adding アイ, ベニ, サンゴ, モエギ,
  オリベ, コン, トキハ, ハネズ, and ヤマブキ, and moved アヤメ to Flower & Plant.
- Migrates v1.5 settings to the reorganized categories.

## 1.5.3 — 2026-09-18

- Fixed the configurable name replacement writing to unused globals instead of
  the game lists that the animal naming screen reads.
- Wait for the game's native lists to initialize before replacing them.

## 1.5.2 — 2026-09-18

- Fixed Japanese candidates not applying in v1.5.1. The generated catalogue
  is now embedded in the MOD's single GML script, avoiding cross-script load
  ordering.

## 1.5.1 — 2026-09-18

- Fixed the generated name catalogue loading after the MOD's registration
  script, which left the native English name pools unchanged despite enabled
  settings. The catalogue now loads first.

## 1.5.0 — 2026-09-18

- Added the enabled-by-default `vanilla_inspired` category with 41 Japanese
  names derived from the game's original English animal-name candidates.
- Added the new category to the editable name catalogue and generated GML.

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
