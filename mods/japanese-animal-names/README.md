# Japanese Animal Names

動物のランダム命名候補を、日本語名へ置き換えるMODです。候補はゲーム本体ではなく、外部の設定ファイルで管理できます。

## まずこれ

- **難易度への影響：低** — 名前候補と命名画面だけを変え、動物の能力・アイテム・収穫・戦闘には影響しません。
- ニワトリ、アヒル、ウサギ、牛、羊、アルパカ、カピバラ、馬、ペットを含む、共通の命名画面を使うすべての動物が対象です。
- 初期状態では、雌雄共通の151個の日本語候補から抽選します。
- 必要：Fields of Mistria と MOMI 0.16.4以降。

## 導入

1. 配布ZIPをVortexなどで導入します。
2. MOMIで **Install** を実行します。
3. ゲームで一度セーブを読み込み、ゲームを終了します。

3の後に編集用設定ファイルが作成されます。Steamの整合性チェック後は、MOMIで再度 **Install** を実行してください。

## 使い方

- 新しく動物に名前を付ける時、サイコロボタンで日本語候補を抽選できます。
- 動物図鑑の名前欄を押すと、本編の新規命名画面を開けます。IMEを切り替えずに、サイコロで改名候補を選べます。
- すでに付いている名前は変更しません。

## 設定

初回ロード後に、次のファイルが作成されます。編集する時はゲームを完全に終了し、保存後に再起動してください。

`%LOCALAPPDATA%\FieldsOfMistria\mod_data\japanese_animal_names\japanese_animal_names.json`

| 設定 | 初期値 | 内容 |
| --- | --- | --- |
| `enabled` | `true` | `false` にすると、本編の英語候補を使います。 |
| `use_naming_popup` | `true` | 動物図鑑から本編の新規命名画面を開きます。 |
| `categories.pet_style` | `true` | ココ、モモ、ルル、モフなど。 |
| `categories.sweets` | `true` | モチ、アンコ、プリン、マカロンなど。 |
| `categories.season_nature` | `true` | ハル、アキ、アサヒ、モミジ、シグレ、カスミなど。 |
| `categories.flower_plant` | `true` | ツバキ、スミレ、サクラ、カリン、アヤメ、アンズなど。 |
| `categories.color_inspired` | `true` | コガネ、アサギ、ルリ、モエギ、サンゴ、ヤマブキなど。 |
| `categories.vanilla_inspired` | `true` | 本編候補に由来するピクルス、ピーナッツ、オーロラ、ジュノなど。 |
| `categories.custom` | `true` | `custom_names` の候補を使います。 |
| `custom_names` | `[]` | 自由に追加する候補。ひらがな・漢字・カタカナを混在できます。 |

`custom_names` は空白を除いて1〜12文字です。同じ名前は1回だけ採用されます。`enabled` が `false`、または全カテゴリと `custom_names` が空の場合は、安全のため本編の英語候補を変更しません。

## 古い設定からの更新

編集用JSONはMOD更新時にも残ります。v1.7.2以前の設定では、動物図鑑から新規命名画面を開く機能がONになります。v1.5.x以前の季節・自然カテゴリ、v1.3.0以前の候補編集も、既存の編集内容を残す形で移行します。

## 候補を追加する人向け

配布後の候補はJSONで追加できます。MOD本体の候補を開発・分類する時は、[`catalog/name-catalog.toml`](catalog/name-catalog.toml) を使います。

- `source = "mod"`：MODの日本語候補としてゲームへ追加されます。
- `source = "vanilla"`：本編の英語候補の参照記録です。ゲームへは追加されません。
- `sex = "shared"`：雌雄共通です。

台帳を編集したら、次を実行します。

```powershell
powershell -ExecutionPolicy Bypass -File tools\Build-JapaneseAnimalNamesCatalog.ps1
```

候補一覧を直接編集せず、実行後に `git diff` で確認してください。ID重複・不明カテゴリ・必須カテゴリの欠落はスクリプトがエラーにします。

## 変更しないこと

- 動物の種類、性別、能力、販売価格、すでに付いた名前。
- 日本語候補を無効にした時の本編の英語候補。
- ゲーム本体のアセット。

動作確認・不具合の記録は、リポジトリ直下の [COMPATIBILITY_AND_BUG_LOG.md](../../COMPATIBILITY_AND_BUG_LOG.md) を参照してください。

Author: mitarasi35
