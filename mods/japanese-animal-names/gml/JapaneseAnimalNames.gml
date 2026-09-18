// Japanese Animal Names
// User-editable config: mod_data/japanese_animal_names/japanese_animal_names.json

#macro JAPANESE_ANIMAL_NAMES_CONFIG_VERSION 2

function __japanese_animal_names_runtime() {
    if (global[$ "__japanese_animal_names"] == undefined) {
        global.__japanese_animal_names = { cfg: undefined, applied: false };
    }
    return global.__japanese_animal_names;
}

function japanese_animal_names_pet_style() {
    return [
        "ココ", "モモ", "モコ", "ルル", "ララ", "ナナ", "ミミ", "ニコ", "ポポ", "ピピ",
        "リン", "メイ", "マル", "ポン", "ハナ", "ソラ", "ユキ", "ツキ", "モフ"
    ];
}

function japanese_animal_names_sweets() {
    return [
        "モチ", "アンコ", "ダンゴ", "オハギ", "キナコ", "アズキ", "ミルク", "ココア", "チョコ",
        "プリン", "クッキー", "マカロン", "シフォン", "バニラ", "キャラメル", "ハチミツ", "ミツ", "マメ",
        "カステラ", "ドラヤキ"
    ];
}

function japanese_animal_names_season_weather() {
    return ["ハル", "ナツ", "アキ", "フユ", "ツユ", "ミゾレ", "コヨミ"];
}

function japanese_animal_names_nature() {
    return [
        "サクラ", "ホシ", "カゼ", "アサヒ", "ユウヒ", "ワカバ", "モミジ", "コハル", "コナツ",
        "スズカゼ", "ナギサ", "アラレ", "ハツユキ"
    ];
}

function japanese_animal_names_color_inspired() {
    return [
        "コガネ", "アサギ", "アカネ", "エンジ", "スオウ", "ルリ", "コンペキ", "フジ", "ナデシコ",
        "アヤメ", "ヒスイ", "カスミ", "トキ", "ウグイス", "カラシ", "アケ", "アオニ", "コハク"
    ];
}

function japanese_animal_names_append(_target, _source) {
    for (var _index = 0; _index < array_length(_source); _index++) {
        array_push(_target, _source[_index]);
    }
    return _target;
}

function japanese_animal_names_defaults() {
    var _names = [];
    _names = japanese_animal_names_append(_names, japanese_animal_names_pet_style());
    _names = japanese_animal_names_append(_names, japanese_animal_names_sweets());
    _names = japanese_animal_names_append(_names, japanese_animal_names_season_weather());
    _names = japanese_animal_names_append(_names, japanese_animal_names_nature());
    _names = japanese_animal_names_append(_names, japanese_animal_names_color_inspired());
    return _names;
}

function japanese_animal_names_category_defaults() {
    return {
        pet_style: true,
        sweets: true,
        season_weather: true,
        nature: true,
        color_inspired: true,
        custom: true,
    };
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

function japanese_animal_names_config_bool(_source, _key, _fallback) {
    if (!is_struct(_source) || typeof(_source[$ _key]) != "bool") return _fallback;
    return _source[$ _key];
}

function japanese_animal_names_same_names(_left, _right) {
    if (!is_array(_left) || !is_array(_right) || array_length(_left) != array_length(_right)) return false;
    for (var _index = 0; _index < array_length(_left); _index++) {
        if (_left[_index] != _right[_index]) return false;
    }
    return true;
}

function japanese_animal_names_read_categories(_source, _fallback) {
    var _categories = is_struct(_source) ? _source : {};
    return {
        pet_style: japanese_animal_names_config_bool(_categories, "pet_style", _fallback.pet_style),
        sweets: japanese_animal_names_config_bool(_categories, "sweets", _fallback.sweets),
        season_weather: japanese_animal_names_config_bool(_categories, "season_weather", _fallback.season_weather),
        nature: japanese_animal_names_config_bool(_categories, "nature", _fallback.nature),
        color_inspired: japanese_animal_names_config_bool(_categories, "color_inspired", _fallback.color_inspired),
        custom: japanese_animal_names_config_bool(_categories, "custom", _fallback.custom),
    };
}

function japanese_animal_names_config() {
    var _rt = __japanese_animal_names_runtime();
    if (_rt.cfg != undefined) return _rt.cfg;

    var _defaults = japanese_animal_names_defaults();
    var _category_defaults = japanese_animal_names_category_defaults();
    var _source = mmapi_config_load("japanese_animal_names");
    var _version = is_struct(_source) ? _source[$ "__config_version"] : undefined;

    if (_version == JAPANESE_ANIMAL_NAMES_CONFIG_VERSION) {
        _rt.cfg = {
            enabled: japanese_animal_names_config_bool(_source, "enabled", true),
            categories: japanese_animal_names_read_categories(_source[$ "categories"], _category_defaults),
            custom_names: japanese_animal_names_validated_names(_source[$ "custom_names"], []),
        };
    } else if (_version == 1 && is_array(_source[$ "names"])) {
        // v1 stored one complete list. Preserve a player's edited list exactly:
        // it becomes the Custom group while built-in groups remain disabled.
        // An untouched v1 default instead migrates to the selectable groups.
        var _legacy_names = japanese_animal_names_validated_names(_source[$ "names"], _defaults);
        if (japanese_animal_names_same_names(_legacy_names, _defaults)) {
            _rt.cfg = {
                enabled: true,
                categories: _category_defaults,
                custom_names: [],
            };
        } else {
            _rt.cfg = {
                enabled: true,
                categories: {
                    pet_style: false,
                    sweets: false,
                    season_weather: false,
                    nature: false,
                    color_inspired: false,
                    custom: true,
                },
                custom_names: _legacy_names,
            };
        }
    } else {
        _rt.cfg = {
            enabled: true,
            categories: _category_defaults,
            custom_names: [],
        };
    }

    mmapi_config_write("japanese_animal_names", JAPANESE_ANIMAL_NAMES_CONFIG_VERSION, _rt.cfg);
    return _rt.cfg;
}

function japanese_animal_names_selected_names(_cfg) {
    var _names = [];
    if (_cfg.categories.pet_style) _names = japanese_animal_names_append(_names, japanese_animal_names_pet_style());
    if (_cfg.categories.sweets) _names = japanese_animal_names_append(_names, japanese_animal_names_sweets());
    if (_cfg.categories.season_weather) _names = japanese_animal_names_append(_names, japanese_animal_names_season_weather());
    if (_cfg.categories.nature) _names = japanese_animal_names_append(_names, japanese_animal_names_nature());
    if (_cfg.categories.color_inspired) _names = japanese_animal_names_append(_names, japanese_animal_names_color_inspired());
    if (_cfg.categories.custom) _names = japanese_animal_names_append(_names, _cfg.custom_names);
    return japanese_animal_names_validated_names(_names, []);
}

function japanese_animal_names_apply_config() {
    var _rt = __japanese_animal_names_runtime();
    if (_rt.applied) return;

    var _cfg = japanese_animal_names_config();
    // Do not overwrite either native pool when the MOD is disabled, or when
    // every category is disabled and Custom has no valid names.
    if (!_cfg.enabled) {
        _rt.applied = true;
        return;
    }

    var _names = japanese_animal_names_selected_names(_cfg);
    if (array_length(_names) == 0) {
        _rt.applied = true;
        return;
    }

    global[$ "MALE_ANIMAL_NAMES"] = ListFromArray(_names);
    global[$ "FEMALE_ANIMAL_NAMES"] = ListFromArray(_names);
    _rt.applied = true;
}

mmapi_mod_declare("japanese_animal_names", "1.4.0");
mmapi_register(japanese_animal_names_apply_config);
