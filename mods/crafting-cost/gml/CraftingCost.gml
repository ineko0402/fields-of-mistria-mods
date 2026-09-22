// Crafting Cost
// Shows the shipping value consumed by a selected crafting recipe.

#macro CRAFTING_COST_CONFIG_VERSION 1

function __crafting_cost_runtime() {
    if (global[$ "__crafting_cost"] == undefined) {
        global.__crafting_cost = {
            registered: false,
            cfg: undefined,
        };
    }
    return global.__crafting_cost;
}

function crafting_cost_config() {
    var _rt = __crafting_cost_runtime();
    if (_rt.cfg != undefined) return _rt.cfg;

    var _source = mmapi_config_read_valid("crafting_cost", CRAFTING_COST_CONFIG_VERSION);
    _rt.cfg = {
        enabled: mmapi_config_bool(_source, "enabled", true),
    };
    mmapi_config_write("crafting_cost", CRAFTING_COST_CONFIG_VERSION, _rt.cfg);
    return _rt.cfg;
}

function crafting_cost_component_count(_component, _output_item_id) {
    // get_modified_component_count() also writes perk statistics. This UI-only
    // calculation mirrors its material-saving perks without changing any
    // gameplay records every time the selected recipe is redrawn.
    var _count = _component.count;
    switch _output_item_id {
        case ItemId.CopperIngot:
            if (ARI.perk_active(Perk.CopperExpert)) return max(_count - 1, 0);
            break;
        case ItemId.IronIngot:
            if (ARI.perk_active(Perk.IronExpert)) return max(_count - 1, 0);
            break;
        case ItemId.SilverIngot:
            if (ARI.perk_active(Perk.SilverExpert)) return max(_count - 1, 0);
            break;
        case ItemId.GoldIngot:
            if (ARI.perk_active(Perk.GoldExpert)) return max(_count - 1, 0);
            break;
        case ItemId.MistrilIngot:
            if (ARI.perk_active(Perk.MistrilExpert)) return max(_count - 1, 0);
            break;
    }
    return _count;
}

function crafting_cost_value(_menu) {
    if (_menu == undefined || _menu.item == undefined || _menu.quantity == undefined) return 0;

    var _total = 0;
    var _components = _menu.item.prototype.recipe.components;
    for (var _i = 0; _i < _components.count(); _i++) {
        var _component = _components.get(_i);
        if (_component.type != RecipeComponentType.Item) continue;

        var _ingredient = new LiveItem(_component.item_id);
        var _count = crafting_cost_component_count(_component, _menu.item.item_id);
        _total += _ingredient.bin_value() * _count * _menu.quantity;
    }
    return _total;
}

function crafting_cost_margin(_menu) {
    if (_menu == undefined || _menu.item == undefined || _menu.quantity == undefined) return 0;
    return (_menu.item.bin_value() * _menu.quantity) - crafting_cost_value(_menu);
}

function crafting_cost_refresh_display(_probe, _menu) {
    if (_probe.freed || _menu == undefined || _menu.preview_box == undefined) return;
    if (_menu.item == undefined || _menu.quantity == undefined) return;

    var _signature = format("{}:{}", _menu.item.pretty_print(), _menu.quantity);
    var _current = _menu[$ "__crafting_cost_display"];
    if (_menu[$ "__crafting_cost_signature"] == _signature
        && _current != undefined
        && !_current.freed)
    {
        return;
    }

    _menu.__crafting_cost_signature = _signature;
    var _margin = crafting_cost_margin(_menu);
    var _prefix = _margin > 0 ? "+" : _margin < 0 ? "-" : "±";
    var _lut_key = _margin > 0 ? "quantity_valid" : _margin < 0 ? "quantity_invalid" : "quantity_neutral";

    // The native preview already shows the crafted item's shipping value in
    // its upper-right corner. The lower-right value is the difference between
    // that output value and the materials' shipping value.
    var _icon = ANCHOR.sprite(_menu.preview_box)
        .set_xy(-1, -1)
        .set_align(Align.RightIn, Align.BottomIn)
        .set_sprite(spr_ui_crafting_tesserae_icon);

    ANCHOR.text(_icon)
        .set_text(format("{}{}", _prefix, num_display(abs(_margin))))
        .set_align(Align.LeftOut, Align.Middle)
        .set_sprite_font("item_count")
        .set_lut(_menu.text_lut, _menu.lut_indexes.get(_lut_key));

    _menu.__crafting_cost_display = _icon;
}

function crafting_cost_attach_to_menu(_probe, _menu) {
    if (_probe.freed || _menu == undefined || _menu.preview_box == undefined) return;
    if (_menu[$ "__crafting_cost_attached"] == true) return;
    if (!crafting_cost_config().enabled) return;

    _menu.__crafting_cost_attached = true;
    _probe.set_think_callback(crafting_cost_refresh_display, [_probe, _menu]);
}

function crafting_cost_on_menu_opened(_ctx) {
    var _menu = _ctx[$ "menu"];
    if (_menu == undefined || _menu[$ "type"] != Menu.Crafting) return;

    // The crafting menu builds its preview after opening. This probe waits for
    // that native layout, then observes only the selected recipe and quantity.
    var _probe = ANCHOR.positional(_menu.right_body).set_size(1, 1);
    _probe.set_think_callback(crafting_cost_attach_to_menu, [_probe, _menu]);
}

function crafting_cost_register() {
    var _rt = __crafting_cost_runtime();
    if (_rt.registered) return;
    _rt.registered = true;
    mmapi_on("ui.menu_opened", crafting_cost_on_menu_opened);
}

mmapi_mod_declare("crafting_cost", "0.1.2");
crafting_cost_register();
