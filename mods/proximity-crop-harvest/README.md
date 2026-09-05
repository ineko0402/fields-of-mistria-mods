# Proximity Crop Harvest

完熟した畑の作物、実を付けた低木、実を付けた果樹を、プレイヤーが近くを移動すると自動で収穫する MOMI 用MODです。果樹はゲーム内部の「現在実がある」状態を直接確認してから収穫するため、未成熟・実のない木は揺らしません。ドロップ・再収穫作物の処理はゲーム側に従います。

## 初期設定

- 徒歩: 範囲1マス（3×3マス）
- ミストホース騎乗中: 範囲2マス（5×5マス）
- 常時ON。キー操作はありません。
- 対象は畑に植えた作物、収穫可能な低木、果実のある果樹です。
- 野草、遺物、岩、通常の木は対象外です。

徒歩／騎乗状態が安定した後に、現在の範囲を日本語通知で表示します。マップ切替中の一時的な徒歩状態は通知・収穫ともに抑制します。

## 導入

1. ゲームを終了します。
2. VortexでZIPを導入するか、`proximity_crop_harvest` フォルダをゲームの `mods` フォルダへ配置します。
3. MOMIで Install を実行します。
4. セーブデータを開き、完熟作物の近くを歩くかミストホースで走ります。

## 設定

最初にセーブを読み込むと、次の設定ファイルが自動生成されます。

```text
%LOCALAPPDATA%\FieldsOfMistria\mod_data\proximity_crop_harvest\proximity_crop_harvest.json
```

ゲームを終了してから編集し、再起動してください。

```json
{
  "__config_version": 1,
  "foot_radius_tiles": 1,
  "mounted_radius_tiles": 2,
  "harvest_fruit_bushes": true,
  "harvest_fruit_trees": true,
  "debug_notifications": true
}
```

`foot_radius_tiles` と `mounted_radius_tiles` は 0〜4 を指定できます。`harvest_fruit_bushes` と `harvest_fruit_trees` で低木・果樹を個別に無効化できます。`debug_notifications` を `false` にすると、徒歩・騎乗の状態通知を非表示にできます。

## 注意

既存の Polarity 等、落下アイテムのマグネット範囲を変更するMODとは別機能です。

Author: mitarasi35. MOMI 0.14.0以降が必要です。
