# Pocket Shipping

Turns the trash button in the player inventory into a pocket-sized shipping
bin. Selling happens immediately: the item is removed and its normal shipping
value is added to Ari's gold without waiting for the end of the day. A native
gold display in the upper-right corner shows the updated total and `+amount`
while the inventory is open.

Pocket Shipping changes no game assets and does not change the trash buttons in
storage menus.

## 注意：ゲームプレイ難易度への影響 — 中

アイテムをその場で売却して即時にお金を得られるため、出荷箱へ運ぶ手間と翌日までの待ち時間を省略します。誤売却は元に戻せません。

## 変更すること

- プレイヤーインベントリのゴミ箱ボタンを、対象アイテムを即時売却するボタンへ置き換えます。
- インベントリを開いている間、売却後の所持金と `+金額` を表示します。

## 変更しないこと

- 収納箱など、プレイヤーインベントリ以外のゴミ箱ボタン。
- アイテムの売却価格、品質、出荷可能かどうかのゲームデータ。
- 翌日の出荷箱サマリーに即時売却を追加すること。

動作確認・不具合の記録は、リポジトリ直下の [COMPATIBILITY_AND_BUG_LOG.md](../../COMPATIBILITY_AND_BUG_LOG.md) を参照してください。

## Requirements

- Fields of Mistria
- Mods of Mistria Installer (MOMI) 0.15.10 or newer

## Installation

1. Install the MOD ZIP with Vortex, or put the `pocket-shipping` folder under
   the game's `mods` folder.
2. Run MOMI and choose Install.
3. Start the game.

If Steam verifies the game files, run MOMI again before launching the game.

## How it works

1. Open the player inventory.
2. Pick up an item stack with the cursor.
3. Click the trash button to sell one item immediately.
4. Hold Shift while clicking to sell the entire held stack.

The amount received is the same as the item's normal shipping-bin value. This
includes relevant quality and archaeology-perk bonuses. The sale is also added
to the game's item-sale record, so first-sale recipe unlocks continue to work.

Items with a shipping value of zero cannot be sold or deleted through this
button. This deliberately protects tools and other important items from being
lost by accident. Use another inventory action if you intentionally need to
discard a zero-value item.

## Settings

The settings file is created after the MOD first loads:

`%LOCALAPPDATA%\FieldsOfMistria\mod_data\pocket_shipping\pocket_shipping.json`

| Setting | Default | Description |
| --- | --- | --- |
| `enabled` | `true` | When true, the player-inventory trash button sells eligible items immediately. When false, it remains the original delete-only button. |
| `show_gold_feedback` | `true` | Shows the game's standard upper-right gold counter and animated `+amount` while the player inventory is open. |

## Compatibility

- Compatible with ordinary storage MODs because Pocket Shipping only changes
  the player inventory's trash button.
- Do not combine it with another MOD that changes that same button or its
  click behavior.
- Gold is received immediately, rather than being shown in the overnight
  shipping summary.
