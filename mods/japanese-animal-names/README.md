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
      fiddle/ranching/misc.toml
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

`names` の配列を編集してからゲームを再起動すると、雌雄を問わずすべての動物のランダム候補に反映されます。ひらがな・漢字・カタカナは混在できます。空白を除いた1〜12文字の名前を使用でき、同じ名前は1回だけ採用されます。空の候補一覧や壊れたJSONは、既定候補へ安全に戻ります。

```json
{
  "__config_version": 1,
  "names": [
    "ここ",
    "もも",
    "春",
    "琥珀",
    "ルナ",
    "ジュノ"
  ]
}
```

編集用JSONはMOD更新時にも残ります。初期候補そのものを編集したい場合だけ、`fiddle/ranching/misc.toml` のリストを変更します。

## Credits

Author: mitarasi35

日本のペット名の一般的な傾向を参考に、MOD用の独自候補リストを作成しています。第三者のMOD・ゲームアセット・画像は同梱していません。
