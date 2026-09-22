// Essence Infusion Choice
// Lets the player spend Essence to choose a valid crafting infusion.

#macro ESSENCE_INFUSION_CHOICE_CONFIG_VERSION 1
#macro ESSENCE_INFUSION_CHOICE_TEXT_CHOOSE "mods/essence_infusion_choice/ui/choose_infusion"
#macro ESSENCE_INFUSION_CHOICE_TEXT_CANCEL "mods/essence_infusion_choice/ui/cancel"
#macro ESSENCE_INFUSION_CHOICE_TEXT_NORMAL "mods/essence_infusion_choice/ui/normal_craft"
#macro ESSENCE_INFUSION_CHOICE_TEXT_NOT_ENOUGH "mods/essence_infusion_choice/ui/not_enough_essence"
#macro ESSENCE_INFUSION_CHOICE_TEXT_OPTION "mods/essence_infusion_choice/ui/infusion_option"

function __essence_infusion_choice_runtime() {
    if (global[$ "__essence_infusion_choice"] == undefined) {
        global.__essence_infusion_choice = {
            registered: false,
            cfg: undefined,
        };
    }
    return global.__essence_infusion_choice;
}

function essence_infusion_choice_config() {
    var _rt = __essence_infusion_choice_runtime();
    if (_rt.cfg != undefined) return _rt.cfg;

    var _source = mmapi_config_read_valid("essence_infusion_choice", ESSENCE_INFUSION_CHOICE_CONFIG_VERSION);
    _rt.cfg = {
        enabled: mmapi_config_bool(_source, "enabled", true),
        essence_cost_per_item: mmapi_config_number(_source, "essence_cost_per_item", 20, 0, 999),
        show_normal_craft_option: mmapi_config_bool(_source, "show_normal_craft_option", true),
    };
    mmapi_config_write("essence_infusion_choice", ESSENCE_INFUSION_CHOICE_CONFIG_VERSION, _rt.cfg);
    return _rt.cfg;
}

function essence_infusion_choice_local_get(_value, _key) {
    // English strings come from the fiddle file. Japanese strings are kept in
    // the same localization path, so UI nodes can refresh on a language swap.
    switch _key {
        case ESSENCE_INFUSION_CHOICE_TEXT_CHOOSE:
            return local_language() == "jpn" ? "追加効果を選択" : undefined;
        case ESSENCE_INFUSION_CHOICE_TEXT_CANCEL:
            return local_language() == "jpn" ? "キャンセル" : undefined;
        case ESSENCE_INFUSION_CHOICE_TEXT_NORMAL:
            return local_language() == "jpn" ? "通常クラフト（抽選）" : undefined;
        case ESSENCE_INFUSION_CHOICE_TEXT_NOT_ENOUGH:
            return local_language() == "jpn" ? "魔素が足りません。" : undefined;
        case ESSENCE_INFUSION_CHOICE_TEXT_OPTION:
            return local_language() == "jpn" ? "{}（{}魔素）" : undefined;
    }
    return undefined;
}

function essence_infusion_choice_total_cost(_menu) {
    if (_menu == undefined || _menu.quantity == undefined) return 0;
    return essence_infusion_choice_config().essence_cost_per_item * _menu.quantity;
}

function essence_infusion_choice_show_not_enough_essence() {
    var _popup = popup_creator(
        "misc_local/confirmation",
        ESSENCE_INFUSION_CHOICE_TEXT_NOT_ENOUGH
    );
    _popup.create_button("misc_local/close");
    _popup.spawn();
}

function essence_infusion_choice_start_native(_menu) {
    if (_menu == undefined || _menu[$ "__essence_infusion_choice_native_start"] == undefined) return;
    _menu.__essence_infusion_choice_native_start();
}

function essence_infusion_choice_start_selected(_menu, _infusion) {
    if (_menu == undefined || _menu.item == undefined) return;

    var _cost = essence_infusion_choice_total_cost(_menu);
    if (ARI.essence < _cost) {
        essence_infusion_choice_show_not_enough_essence();
        return;
    }

    // The native sequence calls Recipe.craft_into synchronously before it
    // begins its fade. For this one call, produce the selected infusion and
    // leave game-owned material, time, XP, inventory, and result handling
    // unchanged.
    var _recipe = _menu.item.prototype.recipe;
    var _native_craft_into = method(_recipe, _recipe.craft_into);
    _recipe.__essence_infusion_choice_forced_infusion = _infusion;
    _recipe.craft_into = method(_recipe, function(_list) {
        var _item = new LiveItem(self.item_id);
        _item.infusion = self.__essence_infusion_choice_forced_infusion;
        _list.push(_item);
    });

    ARI.modify_essence(-_cost);
    essence_infusion_choice_start_native(_menu);
    _recipe.craft_into = _native_craft_into;
    _recipe.__essence_infusion_choice_forced_infusion = undefined;
}

function essence_infusion_choice_open(_menu) {
    if (_menu == undefined || _menu.item == undefined || _menu.quantity == undefined) return;
    if (ANCHOR.popup_is_open()) return;

    var _recipe = _menu.item.prototype.recipe;
    var _infusions = _recipe.generate_infusions();
    if (_infusions == undefined || _infusions.is_empty()) {
        essence_infusion_choice_start_native(_menu);
        return;
    }

    var _cost = essence_infusion_choice_total_cost(_menu);
    var _choice = new MultipleChoicePopup(ESSENCE_INFUSION_CHOICE_TEXT_CHOOSE);

    // The first choice receives the menu-back input glyph, so Escape/B acts
    // as a safe cancellation instead of accidentally spending Essence.
    _choice.option(ESSENCE_INFUSION_CHOICE_TEXT_CANCEL, function() {}, []);

    if (essence_infusion_choice_config().show_normal_craft_option) {
        _choice.option(
            ESSENCE_INFUSION_CHOICE_TEXT_NORMAL,
            essence_infusion_choice_start_native,
            [_menu]
        );
    }

    for (var _i = 0; _i < _infusions.count(); _i++) {
        var _selection = _infusions.get(_i);
        var _name = mmapi_local_get(INFUSIONS.get(_selection.infusion).name);
        _choice.option(
            ANCHOR.wrap_for_local(format(mmapi_local_get(ESSENCE_INFUSION_CHOICE_TEXT_OPTION), _name, _cost)),
            essence_infusion_choice_start_selected,
            [_menu, _selection.infusion]
        );
    }
}

function essence_infusion_choice_attach_to_menu(_probe, _menu) {
    if (_probe.freed || _menu == undefined || _menu.item == undefined) return;
    if (_menu[$ "__essence_infusion_choice_attached"] == true) return;
    if (!essence_infusion_choice_config().enabled) return;

    _menu.__essence_infusion_choice_attached = true;
    _menu.__essence_infusion_choice_native_start = method(_menu, _menu.start_craft_sequence);
    _menu.start_craft_sequence = method(_menu, function() {
        essence_infusion_choice_open(self);
    });
}

function essence_infusion_choice_on_menu_opened(_ctx) {
    var _menu = _ctx[$ "menu"];
    if (_menu == undefined || _menu[$ "type"] != Menu.Crafting) return;

    // The native menu finishes building its selected recipe after opening.
    // A small probe waits for that state, then wraps only this menu instance.
    var _probe = ANCHOR.positional(_menu.right_body).set_size(1, 1);
    _probe.set_think_callback(essence_infusion_choice_attach_to_menu, [_probe, _menu]);
}

function essence_infusion_choice_register() {
    var _rt = __essence_infusion_choice_runtime();
    if (_rt.registered) return;
    _rt.registered = true;
    mmapi_on("ui.menu_opened", essence_infusion_choice_on_menu_opened);
    mmapi_filter("local.get", essence_infusion_choice_local_get);
}

mmapi_mod_declare("essence_infusion_choice", "0.1.1");
essence_infusion_choice_register();
