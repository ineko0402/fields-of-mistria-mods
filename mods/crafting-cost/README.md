# Crafting Cost

Shows the shipping-value difference for the selected crafting recipe. The
game's existing positive value in the preview is the crafted item's normal
shipping value; Crafting Cost adds a value beneath it for the finished item's
shipping value minus the materials spent.

The number updates when changing the recipe or craft quantity: `+n` for a
higher output value, `-n` for a lower output value, and `±0` when unchanged.
It works in all native crafting menus that use the shared crafting interface,
including woodcrafting, blacksmithing, cooking, and milling.

## 注意：ゲームプレイ難易度への影響 — 低

クラフト画面へ売却価値の目安を表示するだけの情報補助MODです。レシピ、材料、クラフト結果、時間、販売価格には影響しません。

## 変更すること

- クラフトプレビューに、完成品の出荷額から素材の出荷額を引いた差額を表示します。
- 選択レシピとクラフト個数に合わせて、`+n`、`-n`、`±0` を更新します。

## 変更しないこと

- レシピ、素材の消費数、完成品、クラフト時間、品質、販売価格。
- エッセンス・時間・直接のゴールド消費を含む厳密な損益計算。
- ゲーム本体のクラフト画面データ。

動作確認・不具合の記録は、リポジトリ直下の [COMPATIBILITY_AND_BUG_LOG.md](../../COMPATIBILITY_AND_BUG_LOG.md) を参照してください。

## Requirements

- Fields of Mistria
- Mods of Mistria Installer (MOMI) 0.16.4 or newer

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
