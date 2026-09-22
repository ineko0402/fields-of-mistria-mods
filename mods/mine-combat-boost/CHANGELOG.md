# Changelog

## 0.1.4 — 2026-09-22

- Declare the required `combat.damage` hook for clearer MOMI compatibility checks.
- Use MOMI's version-validated configuration reader.

## 0.1.3

- Added automatic Sonic Boom activation for nearby Essence Bat sonic waves,
  when the Sonic Boom perk is enabled.
- Added safe automatic neutralization for nearby player-targeted Flame Spirit
  fireballs. Flame Spirit fireballs do not have a native return-projectile
  path, so this does not deal damage back to the enemy.
- Added individual configuration options for both new assists.

## 0.1.2

- Added automatic reflection for nearby Rockclod body charges.
- The reflected charge deals the charging Rockclod's own native damage before
  it continues through the game's normal reflected-flight behavior.

## 0.1.1

- Fixed automatic Rockclod reflections to use the incoming stone's native
  damage instead of a fixed 1 damage.

## 0.1.0

- Initial release.
- Added automatic reflection for nearby Rockclod stones.
- Added automatic capture for nearby Rockclod bombs when there is inventory space.
- Added a Shield Break assist for attacks against shelled mushrooms.
