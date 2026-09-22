# Fields of Mistria Mods

`mitarasi35` 名義で制作する、*Fields of Mistria* 用の MOMI（Mods of Mistria Installer）MODのソース管理リポジトリです。

## MOD一覧

| MOD | 内容 | 現在の版 |
| --- | --- | --- |
| [Japanese Animal Names](mods/japanese-animal-names/README.md) | 動物のランダム名候補を日本語名に置き換え、名前グループを設定できます。 | 1.8.2 |
| [Harvest Horse Boost](mods/harvest-horse-boost/README.md) | ミストホースの Harvest Horse を、収穫・発掘・自動降車で使いやすくします。 | 1.1.6 |
| [Map Warp](mods/map-warp/README.md) | マップ画面から解放済みの屋外地域へワープします。 | 0.1.6 |
| [Mine Combat Boost](mods/mine-combat-boost/README.md) | Rockclodの投射物・突進、特殊な敵攻撃を扱いやすくする戦闘補助です。 | 0.1.4 |
| [Pocket Shipping](mods/pocket-shipping/README.md) | インベントリのゴミ箱から、アイテムを即時に出荷価格で売却します。 | 0.1.2 |
| [Crafting Cost](mods/crafting-cost/README.md) | クラフト後の出荷額と素材の出荷額の差を表示します。 | 0.1.2 |
| [Essence Infusion Choice](mods/essence-infusion-choice/README.md) | 魔素を使い、クラフトの追加効果を指定できます。 | 0.1.1 |
| [Essence Infusion Choice](mods/essence-infusion-choice/README.md) | 魔素を使い、クラフトの追加効果を指定できます。 | 0.1.0 |

## 方針

- ゲーム本体のアセットは直接変更しません。
- 配布用ZIP、利用者の設定ファイル、ログ、MOMIの生成物はリポジトリに含めません。
- 配布前には [MOD_CHECKLIST.md](MOD_CHECKLIST.md) を使って確認します。
- ゲーム本編・MOMI更新時の確認結果と不具合の履歴は、[COMPATIBILITY_AND_BUG_LOG.md](COMPATIBILITY_AND_BUG_LOG.md) に記録します。
- 各MODのゲーム内作者表記は `mitarasi35`、GitHubの管理アカウントは `ineko0402` です。

## 配布

リリースごとにMOD単位のZIPを作成し、Nexus Modsでは同じZIPを配布します。導入には MOMI が必要です。

## License

このリポジトリ内の自作コードは [MIT License](LICENSE) です。ゲーム本体、MOMI、第三者MODのファイルには適用されません。
