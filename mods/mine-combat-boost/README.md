# Mine Combat Boost

鉱山の一部の特殊な敵ギミックを、自動反射・回収・無効化する戦闘補助MODです。

## まずこれ

- **難易度への影響：高** — 特殊攻撃への操作と鉱山での危険を大きく減らします。
- Rockclodの石と突進を反射し、爆弾を回収します。
- Sonic Boomを自動発動し、Flame Spiritの火球を無効化します。
- 必要：Fields of Mistria と MOMI 0.16.4以降。

通常の敵の体力・攻撃力・出現率・ドロップ率・経験値や、ゲームアセットは変更しません。

## 導入

1. 配布ZIPをVortexなどで導入します。
2. MOMIで **Install** を実行します。
3. ゲームを起動します。

Steamの整合性チェック後は、MOMIで再度 **Install** を実行してください。

## できること

- **Rockclodの石を自動反射**：近づいた石を、本編の反射処理と本来のダメージ量で返します。
- **Rockclodの突進を自動反射**：近くの突進を反射状態にし、その敵の突進ダメージと同じ量を与えます。
- **Rockclodの爆弾を自動回収**：虫取り網で捕まえる時と同じく、Bombを1個入手します。インベントリが満杯なら何もしません。
- **殻状態のキノコを攻撃可能に**：プレイヤー側の攻撃に本編の `Shield Break` を適用します。
- **Sonic Boomを自動発動**：Sonic Boomパーク取得中、近くのEssence Batの超音波で本編のSonic Boomを発動します。
- **Flame Spiritの火球を無効化**：近くのプレイヤー狙い火球を安全に消します。石と違い、敵へ反射はできません。

Rock Stack、Mimicなど、状態遷移を伴う無敵処理は対象外です。

## 設定

初回ロード後に、次のファイルが作成されます。編集する時はゲームを完全に終了し、保存後に再起動してください。

`%LOCALAPPDATA%\FieldsOfMistria\mod_data\mine_combat_boost\mine_combat_boost.json`

| 設定 | 初期値 | 内容 |
| --- | --- | --- |
| `enabled` | `true` | 全機能を有効にします。 |
| `auto_reflect_rocks` | `true` | Rockclodの石を反射します。 |
| `auto_reflect_charges` | `true` | Rockclodの突進を反射します。 |
| `auto_capture_bombs` | `true` | Rockclodの爆弾を回収します。 |
| `mushroom_shell_break` | `true` | 殻状態のキノコへ攻撃を通します。 |
| `auto_sonic_boom` | `true` | Sonic Boomを自動発動します。 |
| `auto_neutralize_flame_projectiles` | `true` | Flame Spiritの火球を無効化します。 |
| `assist_radius_tiles` | `1.5` | 自動処理の範囲。1〜3マス。 |
| `debug_notifications` | `false` | 開発・確認用の英語通知を表示します。 |

不正な設定値は、次回ロード時に安全な初期値へ戻ります。

## 互換性と注意

- Rockclodの投射物や全体的な戦闘ダメージを変更するMODとは重複する可能性があります。
- 爆弾回収には虫取り網のアニメーションとスタミナ消費がありません。
- 大型の戦闘MODと併用する時は、セーブデータをバックアップして確認してください。

動作確認・不具合の記録は、リポジトリ直下の [COMPATIBILITY_AND_BUG_LOG.md](../../COMPATIBILITY_AND_BUG_LOG.md) を参照してください。
