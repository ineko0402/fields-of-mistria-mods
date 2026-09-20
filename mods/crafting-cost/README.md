# Crafting Cost

Shows the shipping-value difference for the selected crafting recipe. The
game's existing positive value in the preview is the crafted item's normal
shipping value; Crafting Cost adds a value beneath it for the finished item's
shipping value minus the materials spent.

The number updates when changing the recipe or craft quantity: `+n` for a
higher output value, `-n` for a lower output value, and `±0` when unchanged.
It works in all native crafting menus that use the shared crafting interface,
including woodcrafting, blacksmithing, cooking, and milling.

## Requirements

- Fields of Mistria
- Mods of Mistria Installer (MOMI) 0.15.10 or newer

## Installation

1. Install the MOD ZIP with Vortex, or put the `crafting-cost` folder under the
   game's `mods` folder.
2. Run MOMI and choose Install.
3. Start the game and open a crafting station.

If Steam verifies the game files, run MOMI again before launching the game.

## Calculation

- Uses each required item's normal shipping-bin value, not the store purchase
  price.
- Multiplies by the material count and the selected craft quantity.
- Includes the game's material-saving ingot perks when they apply.
- Does not include Essence, time, or direct gold requirements: it is the value
  of physical materials being consumed.
- Recipes that let the player choose an ingredient category are not given a
  guessed value.

Quality is not specified by a recipe, so the display uses the base shipping
value for that ingredient. It is an opportunity-cost guide, not a record of
the exact individual stack the game will remove.

## Settings

The settings file is created after the MOD first loads:

`%LOCALAPPDATA%\FieldsOfMistria\mod_data\crafting_cost\crafting_cost.json`

| Setting | Default | Description |
| --- | --- | --- |
| `enabled` | `true` | Shows the shipping-value difference in crafting previews. |

## Compatibility

- This MOD only adds a display node to the native crafting preview. It does
  not alter recipes, inventory, crafting time, quality, or sale prices.
- Do not combine it with another MOD that changes the same crafting-preview
  price area without testing both together.
