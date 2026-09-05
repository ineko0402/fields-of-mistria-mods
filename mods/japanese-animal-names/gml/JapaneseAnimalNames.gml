// Japanese Animal Names
// User-editable config: mod_data/japanese_animal_names/japanese_animal_names.json

#macro JAPANESE_ANIMAL_NAMES_CONFIG_VERSION 1

function __japanese_animal_names_runtime() {
    if (global[$ "__japanese_animal_names"] == undefined) {
        global.__japanese_animal_names = { cfg: undefined, applied: false };
    }
    return global.__japanese_animal_names;
}

function japanese_animal_names_defaults() {
    return [
        "ココ", "モモ", "モコ", "ルル", "ララ", "ナナ", "ミミ", "ニコ", "ポポ", "ピピ",
        "リン", "メイ", "マル", "ポン", "ハナ", "ソラ", "ユキ", "ツキ", "モフ",
        "モチ", "アンコ", "ダンゴ", "オハギ", "キナコ", "アズキ", "ミルク", "ココア", "チョコ",
        "プリン", "クッキー", "マカロン", "シフォン", "バニラ", "キャラメル", "ハチミツ", "ミツ", "マメ",
        "カステラ", "ドラヤキ",
        "ハル", "ナツ", "アキ", "フユ", "ツユ", "ミゾレ", "コヨミ", "サクラ", "ホシ", "カゼ",
        "アサヒ", "ユウヒ", "ワカバ", "モミジ", "コハル", "コナツ", "スズカゼ", "ナギサ", "アラレ", "ハツユキ",
        "コガネ", "アサギ", "アカネ", "エンジ", "スオウ", "ルリ", "コンペキ", "フジ", "ナデシコ", "アヤメ",
        "ヒスイ", "カスミ", "トキ", "ウグイス", "カラシ", "アケ", "アオニ", "コハク"
    ];
}

function japanese_animal_names_validated_names(_source, _fallback) {
    if (!is_array(_source)) return _fallback;

    var _names = [];
    for (var _index = 0; _index < array_length(_source); _index++) {
        var _name = _source[_index];
        if (!is_string(_name)) continue;

        _name = string_trim(_name);
        // Allow hiragana, kanji, katakana, and short romanized/casual names.
        // The limit avoids names that overflow the game's naming UI.
        if (string_length(_name) < 1 || string_length(_name) > 12) continue;

        var _duplicate = false;
        for (var _seen = 0; _seen < array_length(_names); _seen++) {
            if (_names[_seen] == _name) {
                _duplicate = true;
                break;
            }
        }
        if (!_duplicate) array_push(_names, _name);
    }

    if (array_length(_names) == 0) return _fallback;
    return _names;
}

function japanese_animal_names_config() {
    var _rt = __japanese_animal_names_runtime();
    if (_rt.cfg != undefined) return _rt.cfg;

    var _defaults = japanese_animal_names_defaults();
    var _source = mmapi_config_read_valid("japanese_animal_names", JAPANESE_ANIMAL_NAMES_CONFIG_VERSION);
    var _names = japanese_animal_names_validated_names(mmapi_config_get(_source, "names", _defaults), _defaults);

    _rt.cfg = { names: _names };
    mmapi_config_write("japanese_animal_names", JAPANESE_ANIMAL_NAMES_CONFIG_VERSION, _rt.cfg);
    return _rt.cfg;
}

function japanese_animal_names_apply_config() {
    var _rt = __japanese_animal_names_runtime();
    if (_rt.applied) return;

    var _cfg = japanese_animal_names_config();
    global[$ "MALE_ANIMAL_NAMES"] = ListFromArray(_cfg.names);
    global[$ "FEMALE_ANIMAL_NAMES"] = ListFromArray(_cfg.names);
    _rt.applied = true;
}

mmapi_mod_declare("japanese_animal_names", "1.3.0");
mmapi_register(japanese_animal_names_apply_config);
