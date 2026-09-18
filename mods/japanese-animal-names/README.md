# Japanese Animal Names

Fields of Mistria のランダム命名候補を日本語化する MOMI 用 MOD です。MOMI (Mods of Mistria Installer) 0.14.0 以降が必要です。候補はゲーム本体やMODフォルダとは別のJSON設定ファイルで編集できます。

対象は、ニワトリ、アヒル、ウサギ、牛、羊、アルパカ、カピバラ、馬、ペットを含む、共通のランダム命名画面を使用するすべての動物です。初期状態では雌雄共通の77個の日本語候補から抽選します。

## 導入

1. ゲームを終了します。
2. この `japanese-animal-names` フォルダを、ゲームフォルダの `mods` 直下へ置きます。
3. `ModsOfMistriaInstaller-cli.exe` または MOMI のGUIを実行し、Install を選びます。
4. ゲームを起動します。

初回導入後は、セーブデータを一度読み込んでからゲームを終了してください。編集用の設定ファイルが生成されます。

配置後の構造:

```text
Fields of Mistria/
  mods/
    japanese-animal-names/
      manifest.toml
      gml/JapaneseAnimalNames.gml
```

既に名前が付いている動物の名前は変わりません。新規に購入・孵化・取得する動物、または命名画面のランダム決定ボタンで日本語候補が使われます。

## 更新・削除

ゲームまたはMOMIの更新後は、MOMIでInstallをもう一度実行してください。削除時はこのフォルダを `mods` から取り除いてMOMIを再実行します。保存済みの名前はそのまま残ります。

## 候補名を編集する

初回にセーブを読み込むと、次のJSON設定ファイルが生成されます。

```text
%LOCALAPPDATA%\FieldsOfMistria\mod_data\japanese_animal_names\japanese_animal_names.json
```

`%LOCALAPPDATA%` は通常 `C:\Users\あなたのWindowsユーザー名\AppData\Local` です。MODフォルダ・ゲーム本体・Vortexの管理フォルダではありません。

ゲームを終了した状態で編集し、再起動すると反映されます。雌雄を問わず、すべての動物が同じ候補一覧を使用します。

```json
{
  "__config_version": 2,
  "enabled": true,
  "categories": {
    "pet_style": true,
    "sweets": true,
    "season_weather": true,
    "nature": true,
    "color_inspired": true,
    "custom": true
  },
  "custom_names": [
    "ここ",
    "もも",
    "春",
    "琥珀"
  ]
}
```

| 設定 | 初期値 | 内容 |
| --- | --- | --- |
| `enabled` | `true` | `false` にすると日本語候補を適用せず、ゲーム本来の英語候補を使います。 |
| `categories.pet_style` | `true` | ココ、モモ、ルル、モフなどのペット風の短い名前。 |
| `categories.sweets` | `true` | モチ、アンコ、プリン、マカロンなど。 |
| `categories.season_weather` | `true` | ハル、ナツ、アキ、ツユ、ミゾレなど。 |
| `categories.nature` | `true` | サクラ、ホシ、カゼ、ワカバ、ナギサなど。 |
| `categories.color_inspired` | `true` | コガネ、アサギ、ルリ、フジ、ヒスイなど。 |
| `categories.custom` | `true` | `custom_names` に入力した名前を候補へ加えます。 |
| `custom_names` | `[]` | 自由に追加する候補。ひらがな・漢字・カタカナを混在できます。 |

`custom_names` は空白を除いて1〜12文字、同じ名前は1回だけ採用されます。`enabled` を `false` にした場合、または全グループを `false` にして `custom_names` も空の場合は、安全のため本来の英語候補を変更しません。

v1.3.0 の旧設定がある場合、旧候補が既定の77件と一致すれば、全グループ有効の新設定へ自動移行します。旧候補を編集していた場合は、その候補だけを `custom_names` として引き継ぎ、組み込みグループはOFFにします。編集内容は失われません。

編集用JSONはMOD更新時にも残ります。MODフォルダ内のGMLやゲーム本体のアセットを編集する必要はありません。

## Credits

Author: mitarasi35

日本のペット名の一般的な傾向を参考に、MOD用の独自候補リストを作成しています。第三者のMOD・ゲームアセット・画像は同梱していません。
