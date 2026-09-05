# Harvest Horse Boost

ミストホースのスキル **Harvest Horse** を、より使いやすくする MOMI 用MODです。騎乗中は広めの範囲で自動収穫・自動発掘を行い、屋内へ入る時は自動的に馬から降ります。騎乗できない場所では、徒歩用の狭い収穫補助が動作します。

## 機能

### 自動収穫

- 騎乗中は初期設定で範囲2マス（5×5マス）、徒歩時は範囲1マス（3×3マス）。
- 完熟した畑の作物、収穫できる低木、実が付いている果樹が対象です。
- 未成熟の作物や実のない果樹は収穫処理を行わないため、果樹を空振りで揺らしません。
- 収穫物、再収穫作物、季節イベントの限定ドロップはゲーム本来の収穫処理に従います。

野草、岩、通常の木は対象外です。

### 自動発掘

- 騎乗中、範囲内の遺物ポイントを手持ちの道具に関係なく自動で掘り出します。
- 遺物、発掘XP、春・秋の季節イベント限定ドロップは通常どおり得られます。
- シャベルを手に持っている場合だけ、シャベル品質に応じたエッセンス獲得とスタミナ消費をゲーム本来どおり適用します。

### 屋内入口で自動的に馬から降りる

騎乗中に屋内へ続く入口へ向かって移動すると、通常の騎乗／降車切替と同じ処理で馬から降ります。建物、洞窟、階段など、騎乗のまま入れない入口が対象です。馬から降りた次のフレームに、ゲーム本来の処理で入室します。

## 導入

1. ゲームを終了します。
2. 配布ZIPをVortexなどのMOD管理アプリで導入するか、展開した `harvest-horse-boost` フォルダをゲームの `mods` フォルダへ配置します。
3. MOMIで **Install** を実行します。
4. ゲームを起動してセーブデータを開きます。

常時ONで、専用のキー操作はありません。

## 設定

最初にセーブを読み込むと、次の設定ファイルが自動生成されます。

```text
%LOCALAPPDATA%\FieldsOfMistria\mod_data\harvest_horse_boost\harvest_horse_boost.json
```

変更する時はゲームを完全に終了してから編集し、再起動してください。

```json
{
  "__config_version": 2,
  "foot_radius_tiles": 1,
  "mounted_radius_tiles": 2,
  "harvest_fruit_bushes": true,
  "harvest_fruit_trees": true,
  "mounted_auto_excavation": true,
  "auto_dismount_indoors": true,
  "debug_notifications": true
}
```

| 設定名 | 初期値 | 内容 |
| --- | --- | --- |
| `foot_radius_tiles` | `1` | 徒歩時の自動収穫範囲。0〜4マス。 |
| `mounted_radius_tiles` | `2` | 騎乗時の自動収穫・自動発掘範囲。0〜4マス。 |
| `harvest_fruit_bushes` | `true` | 収穫可能な低木を対象にするか。 |
| `harvest_fruit_trees` | `true` | 実のある果樹を対象にするか。 |
| `mounted_auto_excavation` | `true` | 騎乗中の遺物ポイント自動発掘を有効にするか。 |
| `auto_dismount_indoors` | `true` | 屋内へ続く入口で自動的に馬から降りるか。 |
| `debug_notifications` | `true` | 徒歩／騎乗の状態通知を表示するか。 |

範囲 `n` は、プレイヤーを中心とする `(2n + 1) × (2n + 1)` マスです。たとえば範囲2は5×5マスです。

## 注意

- 落下アイテムの回収範囲を変えるMOD（Polarityなど）とは別機能です。
- MOMI 0.14.0以降が必要です。

Author: mitarasi35
