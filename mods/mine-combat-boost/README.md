# Mine Combat Boost

Small combat assists for special mine-enemy mechanics. The MOD does not edit
game assets or change ordinary monster health and damage.

## Features

- **Auto-reflect Rockclod stones:** A normal Rockclod stone that comes close
  to Ari is reflected through the game's own return-projectile behavior, using
  that stone's native damage value.
- **Auto-reflect Rockclod charges:** A Rockclod that launches itself close to
  Ari is turned around through the game's reflected-flight behavior. It also
  receives damage equal to its own body-charge damage.
- **Auto-catch Rockclod bombs:** A nearby bomb is converted into one Bomb item,
  just as when catching it with the bug net. A full inventory leaves the bomb
  untouched, so no item is lost.
- **Mushroom shell break:** Attacks that target a shelled mushroom receive the
  game's `Shield Break` flag. The enemy otherwise uses its normal damage,
  defeat, drop, and experience handling.

Rock Stacks, Mimics, and any other state-based invulnerability are intentionally
outside version 0.1.0. Their state machines defer damage rather than simply
blocking it, so forcing damage through them would be unsafe.

## Requirements

- Fields of Mistria
- Mods of Mistria Installer (MOMI) 0.15.10 or newer

## Installation

1. Put the MOD ZIP in your mod manager, or extract its `mine-combat-boost`
   folder under the game's `mods` folder.
2. Run MOMI and install the MOD.
3. Start the game.

If Steam verifies the game files, run MOMI again before launching the game.

## Settings

The settings file is created on first launch:

`%LOCALAPPDATA%\FieldsOfMistria\mod_data\mine_combat_boost\mine_combat_boost.json`

| Setting | Default | Description |
| --- | --- | --- |
| `enabled` | `true` | Turns every Mine Combat Boost feature on or off. |
| `auto_reflect_rocks` | `true` | Reflect nearby normal Rockclod stones. |
| `auto_reflect_charges` | `true` | Reflect nearby Rockclod body charges. |
| `auto_capture_bombs` | `true` | Capture nearby Rockclod bombs when an inventory slot is available. |
| `mushroom_shell_break` | `true` | Let player-side attacks damage shelled mushrooms. |
| `assist_radius_tiles` | `1.5` | Proximity radius for stone reflection and bomb capture; valid range: 1–3. |
| `debug_notifications` | `false` | Shows an English notification when the MOD first becomes active in a play session. |

Invalid setting values are returned to their safe defaults when the game next
loads the MOD.

## Compatibility and limitations

- This MOD only observes live combat objects and uses the game/MMAPI combat
  paths. It does not overwrite game data files.
- It may overlap with MODs that modify Rockclod projectiles or alter all combat
  damage. Do not use more than one MOD that automatically changes the same
  projectile at once.
- Automatic bomb capture gives no bug-net animation and costs no stamina.
- Test on a backed-up save when combining major combat MODs.
