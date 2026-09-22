# Essence Infusion Choice

Spend Essence to choose a valid crafting infusion instead of relying only on
the game's random infusion roll. The native crafting result, material costs,
crafting time, experience, and item delivery remain game-owned.

## 注意：ゲームプレイ難易度への影響 — 高

本編では追加効果はクラフト時に確率で付与されます。このMODでは魔素を消費して、
本来そのレシピで付与可能な追加効果を指定できます。狙った効果の道具・家具などを
確実に作れるため、クラフトのランダム性と難易度を大きく下げます。

## 変更すること

- 追加効果を持てるレシピでクラフトを実行すると、効果を選ぶ画面を表示します。
- 選んだ追加効果を、クラフトする全個に付与します。
- 1個あたりの魔素消費量にクラフト個数を掛けた分を消費します。
- 必要スキル、アイテムの星数など、本編の追加効果の解放条件を満たす候補だけを表示します。
- 必要なら「通常クラフト（抽選）」を選び、本編どおりの確率抽選で作れます。

## 変更しないこと

- レシピ、素材、クラフト時間、経験値、完成品の基本性能、出荷価格。
- 本編で追加効果を付けられないアイテムへの追加効果付与。
- 本編の追加効果の解放条件。

動作確認・不具合の記録は、リポジトリ直下の
[COMPATIBILITY_AND_BUG_LOG.md](../../COMPATIBILITY_AND_BUG_LOG.md) を参照してください。

## Requirements

- Fields of Mistria
- Mods of Mistria Installer (MOMI) 0.16.4 or newer

## Installation

1. MOD ZIPをVortexで導入して有効化します。
2. MOMIで **Install** を実行します。
3. ゲームを起動し、クラフト台を開きます。

Steamの整合性チェックを行った後は、MOMIを再度Installしてください。

## Settings

初回ロード後に設定ファイルが作成されます。

`%LOCALAPPDATA%\FieldsOfMistria\mod_data\essence_infusion_choice\essence_infusion_choice.json`

| Setting | Default | Description |
| --- | --- | --- |
| `enabled` | `true` | 追加効果選択を有効にします。`false` なら本編どおりのクラフトです。 |
| `essence_cost_per_item` | `20` | 追加効果を指定する際の、完成品1個あたりの魔素消費量。`0`〜`999`。 |
| `show_normal_craft_option` | `true` | 選択画面に、魔素を使わず本編の確率抽選を使う「通常クラフト」を表示します。 |

## Known limits

- まとめてクラフトする場合、1回の選択を完成品すべてへ適用します。魔素も個数分消費します。
- 追加効果の候補数が多いレシピでは、選択画面が縦に長くなります。
- 他のMODが同じクラフト開始処理を変更する場合は競合する可能性があります。
