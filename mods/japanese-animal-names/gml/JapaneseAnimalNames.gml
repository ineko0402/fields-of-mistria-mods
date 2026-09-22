// Japanese Animal Names
// User-editable config: mod_data/japanese_animal_names/japanese_animal_names.json

#macro JAPANESE_ANIMAL_NAMES_CONFIG_VERSION 5

function __japanese_animal_names_runtime() {
    if (global[$ "__japanese_animal_names"] == undefined) {
        global.__japanese_animal_names = { cfg: undefined, applied: false, ui_registered: false };
    }
    return global.__japanese_animal_names;
}

// <generated-name-catalog>
// Generated from catalog/name-catalog.toml. Do not edit by hand.
// Run tools/Build-JapaneseAnimalNamesCatalog.ps1 after editing the TOML.

function japanese_animal_names_pet_style() {
    return [
        "ココ",
        "モモ",
        "モコ",
        "ルル",
        "ララ",
        "ナナ",
        "ミミ",
        "ニコ",
        "ポポ",
        "ピピ",
        "リン",
        "メイ",
        "マル",
        "ポン",
        "ハナ",
        "ソラ",
        "ユキ",
        "ツキ",
        "モフ",
        "チロ"
    ];
}

function japanese_animal_names_sweets() {
    return [
        "モチ",
        "アンコ",
        "ダンゴ",
        "オハギ",
        "キナコ",
        "アズキ",
        "ミルク",
        "ココア",
        "チョコ",
        "プリン",
        "クッキー",
        "マカロン",
        "シフォン",
        "バニラ",
        "キャラメル",
        "ハチミツ",
        "ミツ",
        "マメ",
        "カステラ",
        "ドラヤキ"
    ];
}

function japanese_animal_names_season_nature() {
    return [
        "ハル",
        "ナツ",
        "アキ",
        "フユ",
        "ツユ",
        "ミゾレ",
        "コヨミ",
        "アサヒ",
        "ユウヒ",
        "ワカバ",
        "モミジ",
        "コハル",
        "コナツ",
        "ナギサ",
        "アラレ",
        "ヒナタ",
        "イズミ",
        "シズク",
        "ホクト",
        "シグレ",
        "カスミ"
    ];
}

function japanese_animal_names_flower_plant() {
    return [
        "ツバキ",
        "スミレ",
        "ボタン",
        "キキョウ",
        "ヒマワリ",
        "タンポポ",
        "スズラン",
        "ユリ",
        "ハギ",
        "ヨモギ",
        "クルミ",
        "カエデ",
        "ビワ",
        "ユズ",
        "マツ",
        "ウメ",
        "リンドウ",
        "ツツジ",
        "サクラ",
        "カリン",
        "アヤメ",
        "アンズ",
        "キク",
        "シオン"
    ];
}

function japanese_animal_names_color_inspired() {
    return [
        "コガネ",
        "アサギ",
        "アカネ",
        "エンジ",
        "スオウ",
        "ルリ",
        "コンペキ",
        "フジ",
        "ナデシコ",
        "ヒスイ",
        "トキ",
        "ウグイス",
        "カラシ",
        "アケ",
        "アオニ",
        "コハク",
        "アイ",
        "ベニ",
        "サンゴ",
        "モエギ",
        "オリベ",
        "コン",
        "トキハ",
        "ハネズ",
        "ヤマブキ"
    ];
}

function japanese_animal_names_vanilla_inspired() {
    return [
        "ピクルス",
        "トースト",
        "マンゴー",
        "ココナッツ",
        "バゲット",
        "ピーナッツ",
        "バター",
        "ローフ",
        "ケーキ",
        "パンケーキ",
        "ペッパー",
        "シナモン",
        "アップル",
        "レモン",
        "エビ",
        "クマ",
        "クロ",
        "ゴンタ",
        "リーフ",
        "デイジー",
        "ポピー",
        "ジェイド",
        "オーロラ",
        "サニー",
        "ストーミー",
        "ブリージー",
        "ターボ",
        "ソックス",
        "ハート",
        "ジュノ",
        "ルナ",
        "オリバー",
        "フィン",
        "チャーリー",
        "ミカ",
        "ミーシャ",
        "シャーロット",
        "パイパー",
        "カーメン",
        "エリン",
        "レスリー"
    ];
}

// </generated-name-catalog>

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
    _names = japanese_animal_names_append(_names, japanese_animal_names_season_nature());
    _names = japanese_animal_names_append(_names, japanese_animal_names_flower_plant());
    _names = japanese_animal_names_append(_names, japanese_animal_names_color_inspired());
    return _names;
}

function japanese_animal_names_category_defaults() {
    return {
        pet_style: true,
        sweets: true,
        season_nature: true,
        flower_plant: true,
        color_inspired: true,
        vanilla_inspired: true,
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
        season_nature: japanese_animal_names_config_bool(_categories, "season_nature", _fallback.season_nature),
        flower_plant: japanese_animal_names_config_bool(_categories, "flower_plant", _fallback.flower_plant),
        color_inspired: japanese_animal_names_config_bool(_categories, "color_inspired", _fallback.color_inspired),
        vanilla_inspired: japanese_animal_names_config_bool(_categories, "vanilla_inspired", _fallback.vanilla_inspired),
        custom: japanese_animal_names_config_bool(_categories, "custom", _fallback.custom),
    };
}

function japanese_animal_names_read_v2_categories(_source, _fallback) {
    var _categories = is_struct(_source) ? _source : {};
    var _season_weather = japanese_animal_names_config_bool(_categories, "season_weather", _fallback.season_nature);
    var _nature = japanese_animal_names_config_bool(_categories, "nature", _fallback.season_nature);
    return {
        pet_style: japanese_animal_names_config_bool(_categories, "pet_style", _fallback.pet_style),
        sweets: japanese_animal_names_config_bool(_categories, "sweets", _fallback.sweets),
        season_nature: _season_weather || _nature,
        flower_plant: _fallback.flower_plant,
        color_inspired: japanese_animal_names_config_bool(_categories, "color_inspired", _fallback.color_inspired),
        vanilla_inspired: japanese_animal_names_config_bool(_categories, "vanilla_inspired", _fallback.vanilla_inspired),
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
            use_naming_popup: japanese_animal_names_config_bool(_source, "use_naming_popup", true),
            categories: japanese_animal_names_read_categories(_source[$ "categories"], _category_defaults),
            custom_names: japanese_animal_names_validated_names(_source[$ "custom_names"], []),
        };
    } else if (_version == 4 || _version == 3) {
        _rt.cfg = {
            enabled: japanese_animal_names_config_bool(_source, "enabled", true),
            use_naming_popup: true,
            categories: japanese_animal_names_read_categories(_source[$ "categories"], _category_defaults),
            custom_names: japanese_animal_names_validated_names(_source[$ "custom_names"], []),
        };
    } else if (_version == 2) {
        _rt.cfg = {
            enabled: japanese_animal_names_config_bool(_source, "enabled", true),
            use_naming_popup: true,
            categories: japanese_animal_names_read_v2_categories(_source[$ "categories"], _category_defaults),
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
                use_naming_popup: true,
                categories: _category_defaults,
                custom_names: [],
            };
        } else {
            _rt.cfg = {
                enabled: true,
                use_naming_popup: true,
                categories: {
                    pet_style: false,
                    sweets: false,
                    season_nature: false,
                    flower_plant: false,
                    color_inspired: false,
                    vanilla_inspired: false,
                    custom: true,
                },
                custom_names: _legacy_names,
            };
        }
    } else {
        _rt.cfg = {
            enabled: true,
            use_naming_popup: true,
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
    if (_cfg.categories.season_nature) _names = japanese_animal_names_append(_names, japanese_animal_names_season_nature());
    if (_cfg.categories.flower_plant) _names = japanese_animal_names_append(_names, japanese_animal_names_flower_plant());
    if (_cfg.categories.color_inspired) _names = japanese_animal_names_append(_names, japanese_animal_names_color_inspired());
    if (_cfg.categories.vanilla_inspired) _names = japanese_animal_names_append(_names, japanese_animal_names_vanilla_inspired());
    if (_cfg.categories.custom) _names = japanese_animal_names_append(_names, _cfg.custom_names);
    return japanese_animal_names_validated_names(_names, []);
}

function japanese_animal_names_apply_config() {
    var _rt = __japanese_animal_names_runtime();
    if (_rt.applied) return;

    // FiddleParsers creates the native lists during game startup. The names
    // exposed in that script are macros for these two actual global fields;
    // wait until they exist, then replace the lists once.
    if (global.__male_animal_names == undefined || global.__female_animal_names == undefined) return;

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

    global.__male_animal_names = ListFromArray(_names);
    global.__female_animal_names = ListFromArray(_names);
    _rt.applied = true;
}

function japanese_animal_names_open_naming_popup(_menu) {
    if (_menu == undefined || _menu.selected_animal == undefined) return;

    var _animal = _menu.selected_animal;
    var _popup = create_animal_naming_popup(_animal);
    // Popup callbacks do not retain variables from this function's scope.
    // Pass the popup explicitly alongside the target animal instead.
    _popup.create_button("misc_local/confirm", function(_menu, _animal, _popup_to_save) {
        if (_menu == undefined || _menu.selected_animal == undefined) return;
        if (_popup_to_save == undefined) return;
        _animal.name = _popup_to_save.name_input.get_text();
        _menu.select_animal(_animal);
        _menu.right_pilot.force_select(_menu.name_field);
    }, [_menu, _animal, _popup], undefined, InputId.Interact);
    _popup.spawn();
}

function japanese_animal_names_attach_naming_popup(_probe, _menu) {
    if (_probe.freed || _menu == undefined || _menu.selected_animal == undefined) return;
    if (_menu.name_field == undefined || _menu.name_field.freed) return;
    if (_menu.name_field.blackboard.contains_key("__japanese_animal_names_naming_popup")) return;

    var _cfg = japanese_animal_names_config();
    if (!_cfg.enabled || !_cfg.use_naming_popup) return;

    _menu.name_field.board_set("__japanese_animal_names_naming_popup", true);
    _menu.name_field.set_tap_callback(japanese_animal_names_open_naming_popup, [_menu], true);
}

function japanese_animal_names_on_menu_opened(_ctx) {
    var _menu = _ctx[$ "menu"];
    if (_menu == undefined || _menu[$ "type"] != Menu.Animal) return;

    // This parent persists while the journal rebuilds its individual fields.
    // The probe replaces each newly selected animal's text-only rename action
    // with the native naming popup and is cleaned up when the menu closes.
    var _probe = ANCHOR.positional(_menu.journal.right_full_body).set_size(1, 1);
    _probe.set_think_callback(japanese_animal_names_attach_naming_popup, [_probe, _menu]);
}

function japanese_animal_names_register_ui() {
    var _rt = __japanese_animal_names_runtime();
    if (_rt.ui_registered) return;
    _rt.ui_registered = true;
    mmapi_on("ui.menu_opened", japanese_animal_names_on_menu_opened);
    mmapi_register(japanese_animal_names_apply_config);
}

mmapi_mod_declare("japanese_animal_names", "1.8.2");
japanese_animal_names_register_ui();
